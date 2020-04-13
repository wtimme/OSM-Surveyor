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
}

extension QuestInteractionProvider: QuestInteractionProviding {
    public func questInteraction(for questType: String) -> QuestInteraction? {
        /// TODO: Implement me.
        return nil
    }
}
