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
    var elementGeometryDataManagerMock: ElementGeometryDataManagerMock!

    override func setUpWithError() throws {
        questDataManagerMock = QuestDataManagerMock()
        elementGeometryDataManagerMock = ElementGeometryDataManagerMock()
        
        processor = QuestElementProcessor(questDataManager: questDataManagerMock,
                                          elementGeometryDataManager: elementGeometryDataManagerMock)
    }

    override func tearDownWithError() throws {
        processor = nil
        questDataManagerMock = nil
        elementGeometryDataManagerMock = nil
    }
    
    func testProcess_whenElementIsMissingGeometry_shouldNotInsertIntoDatabase() {
        /// Given
        let elementGeometry: ElementGeometry? = nil
        
        /// When
        processor.processElements([(Node.makeNode(), elementGeometry)],
                                  in: BoundingBox.makeBoundingBox(),
                                  forQuestOfType: "ExampleQuest")
        
        /// Then
        XCTAssertFalse(questDataManagerMock.didCallInsert)
    }
    
    func testProcess_whenBothElementAndGeometryArePresent_shouldInsertQuestIntoDatabase() {
        /// Given
        let questType = "LoremIpsum"
        let elementId = 165
        
        let element: Element = Node.makeNode(id: elementId)
        let elementGeometry: ElementGeometry? = ElementGeometry(type: .node,
                                                                elementId: elementId,
                                                                polylines: nil,
                                                                polygons: nil,
                                                                center: Coordinate(latitude: 0, longitude: 0))
        
        /// When
        processor.processElements([(element, elementGeometry)],
                                  in: BoundingBox.makeBoundingBox(),
                                  forQuestOfType: questType)
        
        /// Then
        XCTAssertTrue(questDataManagerMock.didCallInsert)
        XCTAssertEqual(questDataManagerMock.insertArguments?.questType, questType)
        XCTAssertEqual(questDataManagerMock.insertArguments?.elementId, elementId)
        XCTAssertEqual(questDataManagerMock.insertArguments?.geometry, elementGeometry)
    }

}
