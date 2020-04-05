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

    override func setUpWithError() throws {
        processor = QuestElementProcessor()
    }

    override func tearDownWithError() throws {
        processor = nil
    }

}
