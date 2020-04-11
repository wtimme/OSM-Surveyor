//
//  SettingsCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorProtocol: class {
    func start()
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
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        
        /// Remember the navigation controller so that we can later use it for other actions.
        self.navigationController = navigationController
        
        presentingViewController.present(navigationController, animated: true)
    }
}
