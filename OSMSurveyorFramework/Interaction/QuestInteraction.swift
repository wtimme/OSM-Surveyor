//
//  QuestInteraction.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// The interaction that is possible with a quest.
public struct QuestInteraction {
    public enum AnswerType {
        /// The question can be answered with Yes/No.
        case boolean
    }

    /// The question that is presented to the mapper.
    public let question: String
    
    /// The type of answer that the question can be resolved with.
    public let answerType: AnswerType
}
