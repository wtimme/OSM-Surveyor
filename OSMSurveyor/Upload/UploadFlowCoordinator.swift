//
//  UploadFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

protocol UploadFlowCoordinatorProtocol: class {
    func start(questType: String, questId: Int)
    
    /// Starts the flow for adding a new OpenStreetMap account.
    func startAddAccountFlow()
}

final class UploadFlowCoordinator {
    // MARK: Private properties
    
    private let presentingViewController: UIViewController
    
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
        
        presentingViewController.present(navigationController, animated: true)
    }
    
    func startAddAccountFlow() {
        /// TODO: Implement me.
    }
}
