//
//  QuestInteractionCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

protocol QuestInteractionCoordinatorProtocol: class {
}

final class QuestInteractionCoordinator {
    // MARK: Private properties
    
    private let navigationController: UINavigationController
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension QuestInteractionCoordinator: QuestInteractionCoordinatorProtocol {
}
