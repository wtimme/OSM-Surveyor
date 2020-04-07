//
//  QuestAnnotationManagerTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class QuestAnnotationManagerTestCase: XCTestCase {
    
    private let zoomForTiles = 10
    
    private var manager: QuestAnnotationManaging!
    private var fullQuestsDataProviderMock: FullQuestsDataProviderMock!
    
    private var delegateMock: QuestAnnotationManagerDelegateMock!

    override func setUpWithError() throws {
        fullQuestsDataProviderMock = FullQuestsDataProviderMock()
        
        manager = QuestAnnotationManager(zoomForDownloadedTiles: zoomForTiles,
                                         fullQuestsDataProvider: fullQuestsDataProviderMock)
        
        delegateMock = QuestAnnotationManagerDelegateMock()
        manager.delegate = delegateMock
    }

    override func tearDownWithError() throws {
        manager = nil
        fullQuestsDataProviderMock = nil
        
        delegateMock = nil
    }
    
    func testMapDidUpdateBoundingBox_whenDelegateIsNotSet_shouldNotAskQuestDataProviderForQuests() {
        /// Given
        manager.delegate = nil
        
        /// When
        manager.mapDidUpdatePosition(to: BoundingBox.makeBoundingBox())
        
        /// Then
        XCTAssertFalse(fullQuestsDataProviderMock.didCallFindQuests)
        
    }
    
    func testMapDidUpdateBoundingBox_shouldAskQuestDataProviderForQuests() {
        /// Given
        let boundingBox = BoundingBox.makeBoundingBox()
        
        /// When
        manager.mapDidUpdatePosition(to: boundingBox)
        
        /// Then
        XCTAssertTrue(fullQuestsDataProviderMock.didCallFindQuests)
        XCTAssertEqual(fullQuestsDataProviderMock.findQuestsBoundingBox,
                       boundingBox.asBoundingBoxOfEnclosingTiles(zoom: zoomForTiles))
        
    }
    
    func testMapDidUpdateBoundingBox_whenNoQuestsWereFound_shouldNotAskDelegateToAddAnnotations() {
        /// Given
        fullQuestsDataProviderMock.questsToReturn = []
        
        /// When
        manager.mapDidUpdatePosition(to: BoundingBox.makeBoundingBox())
        
        /// Then
        XCTAssertFalse(delegateMock.didCallAddAnnotations)
    }
    
    func testMapDidUpdateBoundingBox_whenQuestsWereFound_shouldAskDelegateToAddAnnotations() {
        /// Given
        let firstCoordinate = Coordinate(latitude: 1, longitude: 1)
        let secondCoordinate = Coordinate(latitude: 2, longitude: 2)
        let thirdCoordinate = Coordinate(latitude: 3, longitude: 3)
        
        fullQuestsDataProviderMock.questsToReturn = [(firstCoordinate, ""),
                                                     (secondCoordinate, ""),
                                                     (thirdCoordinate, "")]
        
        /// When
        manager.mapDidUpdatePosition(to: BoundingBox.makeBoundingBox())
        
        /// Then
        XCTAssertTrue(delegateMock.didCallAddAnnotations)
        
        let expectedAnnotations = [firstCoordinate, secondCoordinate, thirdCoordinate].map { Annotation(coordinate: $0) }
        XCTAssertEqual(delegateMock.annotations, expectedAnnotations)
    }
    
    func testMapDidUpdateBoundingBox_whenTheAnnotationsForBoundingBoxHaveAlreadyBeenRetrieved_shouldNotAskQuestDataProviderToProvideQuests() {
        /// Given
        let boundingBox = BoundingBox.makeBoundingBox()
        
        /// When
        manager.mapDidUpdatePosition(to: boundingBox)
        manager.mapDidUpdatePosition(to: boundingBox)
        
        /// Then
        XCTAssertEqual(fullQuestsDataProviderMock.findQuestsCallCounter, 1)
    }

}
