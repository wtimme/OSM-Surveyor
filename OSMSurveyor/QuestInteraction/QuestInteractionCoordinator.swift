//
//  QuestInteractionCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import OSMSurveyorFramework

enum QuestInteractionCoordinatorError: Error {
    /// The coordinator is not able to determine the interaction to use for the quest.
    case interactionNotFound
}

protocol QuestInteractionCoordinatorProtocol: class {
    func start(questType: String, questId: Int) throws
}

final class QuestInteractionCoordinator {
    // MARK: Private properties
    
    private let questInteractionProvider: QuestInteractionProviding
    private let uploadFlowCoordinator: UploadFlowCoordinatorProtocol
    private weak var delegate: QuestInteractionDelegate?
    
    // MARK: Initializer
    
    init(questInteractionProvider: QuestInteractionProviding,
         uploadFlowCoordinator: UploadFlowCoordinatorProtocol,
         delegate: QuestInteractionDelegate) {
        self.questInteractionProvider = questInteractionProvider
        self.uploadFlowCoordinator = uploadFlowCoordinator
        self.delegate = delegate
    }
}

extension QuestInteractionCoordinator: QuestInteractionCoordinatorProtocol {
    func start(questType: String, questId: Int) throws {
        guard let interaction = questInteractionProvider.questInteraction(for: questType) else {
            throw QuestInteractionCoordinatorError.interactionNotFound
        }
        
        switch interaction.answerType {
        case .boolean:
            delegate?.presentBooleanQuestInterface(question: interaction.question, answer: { [weak self] _ in
                guard let self = self else { return }
                
                self.uploadFlowCoordinator.start(questType: questType,
                                                 questId: questId)
            })
        }
    }
}
