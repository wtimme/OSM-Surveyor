//
//  UploadFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import OSMSurveyorFramework

protocol UploadFlowCoordinatorProtocol: class {
    func start(questType: String, questId: Int)
    
    /// Starts the flow for adding a new OpenStreetMap account.
    func startAddAccountFlow()
}

final class UploadFlowCoordinator {
    // MARK: Private properties
    
    private let presentingViewController: UIViewController
    private var navigationController: UINavigationController?
    
    private var addAccountCoordinator: AddAccountFlowCoordinatorProtocol?
    
    // MARK: Initializer
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
}

extension UploadFlowCoordinator: UploadFlowCoordinatorProtocol {
    func start(questType: String, questId: Int) {
        let viewModel = UploadViewModel(questId: questId)
        viewModel.coordinator = self
        
        let viewController = UploadViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        
        presentingViewController.present(navigationController, animated: true)
    }
    
    func startAddAccountFlow() {
        guard let navigationController = navigationController else { return }
        
        guard
            let pathToSecretsPropertyList = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let oAuthHandler = OAuthHandler(propertyListPath: pathToSecretsPropertyList),
            let apiClient = OpenStreetMapAPIClient(propertyListPath: pathToSecretsPropertyList)
        else {
            assertionFailure("Unable to initialize the OAuthHandler")
            return
        }
        
        let coordinator = AddAccountFlowCoordinator(presentingViewController: navigationController,
                                                    alertPresenter: navigationController,
                                                    oAuthHandler: oAuthHandler,
                                                    apiClient: apiClient,
                                                    keychainHandler: KeychainHandler())
        addAccountCoordinator = coordinator
        
        coordinator.onFinish = { [weak self] in
            /// Clean up
            self?.addAccountCoordinator = nil
        }
        
        coordinator.start()
    }
}
