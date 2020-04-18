//
//  OverpassQuestTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks

class OverpassQuestTestCase: XCTestCase {

    private class MyExampleQuest: OverpassQuest {
        let interaction = QuestInteraction.makeQuestInteraction()
        
        func query(boundingBox: BoundingBox) -> String { return "" }
        
        let commitMessage = "Lorem ipsum"
    }
    
    func testType_whenUsingDefaultImplementation_shouldReturnClassNameWithoutQuestSuffix() {
        let quest = MyExampleQuest()
        
        XCTAssertEqual(quest.type, "MyExample")
    }

}
