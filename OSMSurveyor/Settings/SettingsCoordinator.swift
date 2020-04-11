//
//  SettingsCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import SafariServices
import OSMSurveyorFramework

protocol SettingsCoordinatorProtocol: class {
    func start()
    
    /// Starts the flow for adding a new OpenStreetMap account.
    func startAddAccountFlow()
    
    /// Presents the app's GitHub repository.
    func presentGitHubRepository()
    
    /// Presents the bug/issue tracker.
    func presentBugTracker()
}

final class SettingsCoordinator {
    // MARK: Private properties
    
    private let presentingViewController: UIViewController
    private var navigationController: UINavigationController?
    
    // MARK: Initializer
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
}

extension SettingsCoordinator: SettingsCoordinatorProtocol {
    func start() {
        let viewModel = SettingsViewModel()
        viewModel.coordinator = self
        
        let settingsViewController = SettingsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        
        /// Remember the navigation controller so that we can later use it for other actions.
        self.navigationController = navigationController
        
        presentingViewController.present(navigationController, animated: true)
    }
    
    func startAddAccountFlow() {
        guard let navigationController = navigationController else { return }
        
        guard
            let pathToSecretsPropertyList = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let oAuthHandler = OAuthHandler(propertyListPath: pathToSecretsPropertyList)
        else {
            assertionFailure("Unable to initialize the OAuthHandler")
            return
        }
        
        let coordinator = AddAccountFlowCoordinator(navigationController: navigationController,
                                                    oAuthHandler: oAuthHandler)
        coordinator.start()
    }
    
    func presentGitHubRepository() {
        guard let url = URL(string: "https://github.com/wtimme/OSM-Surveyor") else { return }
        
        openExternalURL(url)
    }
    
    func presentBugTracker() {
        guard let url = URL(string: "https://github.com/wtimme/OSM-Surveyor/issues") else { return }
        
        openExternalURL(url)
    }
    
    private func openExternalURL(_ url: URL) {
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .currentContext
        
        navigationController?.present(viewController, animated: true)
    }
}
