//
//  OverpassQuestManagerTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class OverpassQuestManagerTestCase: XCTestCase {
    
    private let zoomForTiles = 42
    
    private var manager: OverpassQuestManager!
    private var downloadedQuestTypesManagerMock: DownloadedQuestTypesManagerMock!

    override func setUpWithError() throws {
        downloadedQuestTypesManagerMock = DownloadedQuestTypesManagerMock()
        
        manager = OverpassQuestManager(zoomForDownloadedTiles: zoomForTiles,
                                       downloadedQuestTypesManager: downloadedQuestTypesManagerMock)
    }

    override func tearDownWithError() throws {
        manager = nil
        downloadedQuestTypesManagerMock = nil
    }
    
    // MARK: updateQuests(in:)
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldAskDownloadedQuestTypesManagerForDownloadedQuestTypes() {
        manager.updateQuests(in: BoundingBox(minimum: Coordinate(latitude: 0, longitude: 0),
                                             maximum: Coordinate(latitude: 0, longitude: 0)))
        
        XCTAssertTrue(downloadedQuestTypesManagerMock.didCallFindDownloadedQuestTypes)
    }
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldAskDownloadedQuestTypesManagerForDownloadedQuestTypesWithTheCorrectTilesRect() {
        /// Given
        let boundingBox = BoundingBox(minimum: Coordinate(latitude: 53.0123, longitude: 9.0123),
                                      maximum: Coordinate(latitude: 54.987, longitude: 10.987))
        
        /// When
        manager.updateQuests(in: boundingBox)
        
        /// Then
        XCTAssertEqual(downloadedQuestTypesManagerMock.findDownloadedQuestTypesArguments?.tilesRect,
                       boundingBox.enclosingTilesRect(zoom: zoomForTiles))
    }

}
