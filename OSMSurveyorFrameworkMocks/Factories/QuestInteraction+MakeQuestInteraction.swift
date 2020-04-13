//
//  QuestInteraction+MakeQuestInteraction.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework

extension QuestInteraction {
    static func makeQuestInteraction(question: String = "Lorem ipsum dolor sid?",
                                     answerType: AnswerType = .boolean) -> QuestInteraction {
        return QuestInteraction(question: question,
                                answerType: answerType)
    }
}
