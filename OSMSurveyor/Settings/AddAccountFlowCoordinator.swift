//
//  AddAccountFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import OSMSurveyorFramework

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
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController,
         oAuthHandler: OAuthHandling,
         apiClient: OpenStreetMapAPIClientProtocol) {
        self.navigationController = navigationController
        self.oAuthHandler = oAuthHandler
        self.apiClient = apiClient
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
                self.apiClient.userDetails(oAuthToken: credentials.token, oAuthTokenSecret: credentials.tokenSecret) { userDetailsResult in
                    /// TODO: Implement me.
                }
            }
        }
    }
}
