//
//  OverpassQuestTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
import XCTest

class OverpassQuestTestCase: XCTestCase {
    private class MyExampleQuest: OverpassQuest {
        func query(boundingBox _: BoundingBox) -> String { return "" }
    }

    func testType_whenUsingDefaultImplementation_shouldReturnClassNameWithoutQuestSuffix() {
        let quest = MyExampleQuest()

        XCTAssertEqual(quest.type, "MyExample")
    }
}
