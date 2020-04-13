//
//  QuestInteractionProviderTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

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

}
