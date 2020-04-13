//
//  QuestInteractionProvider.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol QuestInteractionProviding {
    /// Provides the `QuestInteraction` for the quest with the given `questType`.
    /// - Parameter questType: The quest type for which to get the `QuestInteraction`.
    func questInteraction(for questType: String) -> QuestInteraction?
}

public final class QuestInteractionProvider {
    // MARK: Private properties
    
    private let questProvider: OverpassQuestProviding
    
    // MARK: Initializer
    
    init(questProvider: OverpassQuestProviding) {
        self.questProvider = questProvider
    }
    
    public convenience init() {
        self.init(questProvider: StaticOverpassQuestProvider())
    }
}

extension QuestInteractionProvider: QuestInteractionProviding {
    public func questInteraction(for questType: String) -> QuestInteraction? {
        return questProvider.quests.first(where: { $0.type == questType })?.interaction
    }
}
