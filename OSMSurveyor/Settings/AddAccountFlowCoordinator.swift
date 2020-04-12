//
//  AddAccountFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import OSMSurveyorFramework

enum AddAccountFlowCoordinatorError: Error {
    case insufficientPermissions
}

protocol AddAccountFlowCoordinatorProtocol {
    func start()
    
    /// Closure that is executed as soon as the coordinator finished its flow.
    /// In case of a success, the `Result` contains the username.
    var onFinish: ((Result<String, Error>) -> Void)? { set get }
}

final class AddAccountFlowCoordinator {
    // MARK: Public properties
    
    var onFinish: ((Result<String, Error>) -> Void)?
    
    // MARK: Private properties
    
    private let navigationController: UINavigationController
    private let oAuthHandler: OAuthHandling
    private let apiClient: OpenStreetMapAPIClientProtocol
    private let keychainHandler: KeychainHandling
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController,
         oAuthHandler: OAuthHandling,
         apiClient: OpenStreetMapAPIClientProtocol,
         keychainHandler: KeychainHandling) {
        self.navigationController = navigationController
        self.oAuthHandler = oAuthHandler
        self.apiClient = apiClient
        self.keychainHandler = keychainHandler
    }
}

extension AddAccountFlowCoordinator: AddAccountFlowCoordinatorProtocol {
    func start() {
        oAuthHandler.authorize(from: navigationController) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                self.onFinish?(.failure(error))
            case let .success(credentials):
                self.apiClient.permissions(oAuthToken: credentials.token, oAuthTokenSecret: credentials.tokenSecret) { [weak self] permissionResult in
                    guard let self = self else { return }
                    
                    switch permissionResult {
                    case let .failure(error):
                        self.onFinish?(.failure(error))
                    case let .success(permissions):
                        if permissions.contains(.allow_read_prefs), permissions.contains(.allow_write_api) {
                            self.apiClient.userDetails(oAuthToken: credentials.token, oAuthTokenSecret: credentials.tokenSecret) { [weak self] userDetailsResult in
                                guard let self = self else { return }
                                
                                switch userDetailsResult {
                                case let .failure(error):
                                    self.onFinish?(.failure(error))
                                case let .success(userDetails):
                                    self.attemptToAddEntryToKeychain(username: userDetails.username,
                                                                     token: credentials.token,
                                                                     tokenSecret: credentials.tokenSecret)
                                }
                            }
                        } else {
                            self.onFinish?(.failure(AddAccountFlowCoordinatorError.insufficientPermissions))
                        }
                    }
                }
            }
        }
    }
    
    private func attemptToAddEntryToKeychain(username: String,
                                             token: String,
                                             tokenSecret: String) {
        do {
            try keychainHandler.add(username: username, credentials: OAuth1Credentials(token: token, tokenSecret: tokenSecret))
            
            onFinish?(.success(username))
        } catch {
            onFinish?(.failure(error))
        }
    }
}
