//
//  QuestInteractionProviderMock.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework

final class QuestInteractionProviderMock {
    private(set) var didCallQuestInteraction = false
    private(set) var questTypeToRetrieveInteractionFor: String?
    var questInteractionToReturn: QuestInteraction?
}

extension QuestInteractionProviderMock: QuestInteractionProviding {
    func questInteraction(for questType: String) -> QuestInteraction? {
        didCallQuestInteraction = true
        
        questTypeToRetrieveInteractionFor = questType
        
        return questInteractionToReturn
    }
}
