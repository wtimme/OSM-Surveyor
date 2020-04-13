//
//  QuestInteractionDelegate.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// An object that presents the quest interface.
protocol QuestInteractionDelegate: class {
    /// Asks the delegate to present an interface for with a question and yes/no answers.
    /// - Parameters:
    ///   - question: The question to ask.
    ///   - completion: Closure to execute when the user has provided an answer.
    func presentBooleanQuestInterface(question: String,
                                      completion: @escaping (Bool) -> Void)
}
