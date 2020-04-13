//
//  QuestInteractionProviderTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks

class QuestInteractionProviderTestCase: XCTestCase {
    
    private var provider: QuestInteractionProviding!
    private var questProviderMock: OverpassQuestProviderMock!

    override func setUpWithError() throws {
        questProviderMock = OverpassQuestProviderMock()
        
        provider = QuestInteractionProvider(questProvider: questProviderMock)
    }

    override func tearDownWithError() throws {
        provider = nil
        questProviderMock = nil
    }
    
    func testQuestInteraction_whenQuestWithTheGivenTypeExist_shouldReturnNil() {
        questProviderMock.quests = []
        
        XCTAssertNil(provider.questInteraction(for: "example_quest"))
    }
    
    func testQuestInteraction_whenQuestWithTheGivenTypeExists_shouldReturnTheQuestsInteraction() {
        let questType = "example_quest"
        
        let questInteraction = QuestInteraction.makeQuestInteraction()
        let questMock = OverpassQuestMock(type: questType)
        questMock.interaction = questInteraction
        
        questProviderMock.quests = [questMock]
        
        XCTAssertEqual(provider.questInteraction(for: questType), questInteraction)
    }

}
