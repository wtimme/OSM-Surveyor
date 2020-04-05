//
//  QuestElementProcessorTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class QuestElementProcessorTestCase: XCTestCase {
    
    var processor: QuestElementProcessing!
    var questDataManagerMock: QuestDataManagerMock!

    override func setUpWithError() throws {
        questDataManagerMock = QuestDataManagerMock()
        
        processor = QuestElementProcessor(questDataManager: questDataManagerMock)
    }

    override func tearDownWithError() throws {
        processor = nil
        questDataManagerMock = nil
    }

}
