//
//  AddAccountFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

protocol AddAccountFlowCoordinatorProtocol {
    func start()
}

final class AddAccountFlowCoordinator {
    // MARK: Private properties
    
    private let navigationController: UINavigationController
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AddAccountFlowCoordinator: AddAccountFlowCoordinatorProtocol {
    func start() {
    }
}
