//
//  QuestTypeProtocolTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class QuestTypeProtocolTestCase: XCTestCase {

    private class MyExampleQuest: QuestTypeProtocol {
        func download(boundingBox: BoundingBox, using downloader: OverpassDownloading, _ completion: @escaping (Result<[(Element, ElementGeometry?)], Error>) -> Void) {}
    }
    
    func testType_whenUsingDefaultImplementation_shouldReturnClassNameWithoutQuestSuffix() {
        let quest = MyExampleQuest()
        
        XCTAssertEqual(quest.type, "MyExample")
    }

}
