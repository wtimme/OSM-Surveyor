//
//  AddAccountFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import OSMSurveyorFramework
import UIKit

enum AddAccountFlowCoordinatorError: Error {
    case insufficientPermissions
}

protocol AddAccountFlowCoordinatorProtocol {
    func start()

    /// Closure that is executed as soon as the coordinator finished its flow.
    var onFinish: (() -> Void)? { set get }
}

final class AddAccountFlowCoordinator {
    // MARK: Public properties

    var onFinish: (() -> Void)?

    // MARK: Private properties

    private let presentingViewController: UIViewController
    private let alertPresenter: AlertPresenting
    private let oAuthHandler: OAuthHandling
    private let apiClient: OpenStreetMapAPIClientProtocol
    private let keychainHandler: KeychainHandling

    // MARK: Initializer

    init(presentingViewController: UIViewController,
         alertPresenter: AlertPresenting,
         oAuthHandler: OAuthHandling,
         apiClient: OpenStreetMapAPIClientProtocol,
         keychainHandler: KeychainHandling)
    {
        self.presentingViewController = presentingViewController
        self.alertPresenter = alertPresenter
        self.oAuthHandler = oAuthHandler
        self.apiClient = apiClient
        self.keychainHandler = keychainHandler
    }
}

extension AddAccountFlowCoordinator: AddAccountFlowCoordinatorProtocol {
    func start() {
        oAuthHandler.authorize(from: presentingViewController) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                self.handleError(error)
            case let .success(credentials):
                self.apiClient.permissions(oAuthToken: credentials.token, oAuthTokenSecret: credentials.tokenSecret) { [weak self] permissionResult in
                    guard let self = self else { return }

                    switch permissionResult {
                    case let .failure(error):
                        self.handleError(error)
                    case let .success(permissions):
                        if permissions.contains(.allow_read_prefs), permissions.contains(.allow_write_api) {
                            self.apiClient.userDetails(oAuthToken: credentials.token, oAuthTokenSecret: credentials.tokenSecret) { [weak self] userDetailsResult in
                                guard let self = self else { return }

                                switch userDetailsResult {
                                case let .failure(error):
                                    self.handleError(error)
                                case let .success(userDetails):
                                    self.attemptToAddEntryToKeychain(username: userDetails.username,
                                                                     token: credentials.token,
                                                                     tokenSecret: credentials.tokenSecret)
                                }
                            }
                        } else {
                            self.handleError(AddAccountFlowCoordinatorError.insufficientPermissions)
                        }
                    }
                }
            }
        }
    }

    private func attemptToAddEntryToKeychain(username: String,
                                             token: String,
                                             tokenSecret: String)
    {
        do {
            try keychainHandler.add(username: username, credentials: OAuth1Credentials(token: token, tokenSecret: tokenSecret))

            onFinish?()
        } catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        let title: String
        let message: String

        if AddAccountFlowCoordinatorError.insufficientPermissions == (error as? AddAccountFlowCoordinatorError) {
            title = "Insufficient privileges"
            message = "Please allow the app to access ALL OAuth permissions. Do not uncheck the checkboxes! Otherwise, the app will not work properly."
        } else if KeychainError.usernameAlreadyExists == (error as? KeychainError) {
            title = "Account already added"
            message = "An account can only be added once. Please remove the existing one before adding it again."
        } else {
            title = "Error"
            message = error.localizedDescription
        }

        alertPresenter.presentAlert(title: title,
                                    message: message)
    }
}
