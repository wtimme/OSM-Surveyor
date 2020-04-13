//
//  QuestInteractionCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

enum QuestInteractionCoordinatorError: Error {
    /// The coordinator is not able to determine the interaction to use for the quest.
    case interactionNotFound
}

protocol QuestInteractionCoordinatorProtocol: class {
    func start(questType: String, questId: Int)
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
    func start(questType: String, questId: Int) {
        /// TODO: Implement me.
    }
}
