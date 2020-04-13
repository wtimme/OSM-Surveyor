//
//  UploadFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

protocol UploadFlowCoordinatorProtocol {
    func start(questType: String, questId: Int)
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
        let viewController = UploadViewController(questId: questId)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presentingViewController.present(navigationController, animated: true)
    }
}
