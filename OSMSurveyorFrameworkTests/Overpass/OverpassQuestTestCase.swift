//
//  OverpassQuestTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class OverpassQuestTestCase: XCTestCase {

    private class MyExampleQuest: OverpassQuest {
        func query(boundingBox: BoundingBox) -> String { return "" }
    }
    
    func testType_whenUsingDefaultImplementation_shouldReturnClassNameWithoutQuestSuffix() {
        let quest = MyExampleQuest()
        
        XCTAssertEqual(quest.type, "MyExample")
    }

}
