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
    private var questProviderMock: OverpassQuestProviderMock!
    private var queryExecutorMock: OverpassQueryExecutorMock!
    private var downloadedQuestTypesManagerMock: DownloadedQuestTypesManagerMock!
    private var questElementProcessorMock: QuestElementProcessorMock!

    override func setUpWithError() throws {
        questProviderMock = OverpassQuestProviderMock()
        queryExecutorMock = OverpassQueryExecutorMock()
        downloadedQuestTypesManagerMock = DownloadedQuestTypesManagerMock()
        questElementProcessorMock = QuestElementProcessorMock()
        
        manager = OverpassQuestManager(questProvider: questProviderMock,
                                       queryExecutor: queryExecutorMock,
                                       zoomForDownloadedTiles: zoomForTiles,
                                       downloadedQuestTypesManager: downloadedQuestTypesManagerMock,
                                       questElementProcessor: questElementProcessorMock)
    }

    override func tearDownWithError() throws {
        manager = nil
        questProviderMock = nil
        queryExecutorMock = nil
        downloadedQuestTypesManagerMock = nil
        questElementProcessorMock = nil
    }
    
    // MARK: updateQuests(in:)
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldAskDownloadedQuestTypesManagerForDownloadedQuestTypes() {
        manager.updateQuests(in: BoundingBox(minimum: Coordinate(latitude: 0, longitude: 0),
                                             maximum: Coordinate(latitude: 0, longitude: 0)),
                             ignoreDownloadedQuestsBefore: Date())
        
        XCTAssertTrue(downloadedQuestTypesManagerMock.didCallFindDownloadedQuestTypes)
    }
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldAskDownloadedQuestTypesManagerForDownloadedQuestTypesWithTheCorrectTilesRect() {
        /// Given
        let boundingBox = BoundingBox(minimum: Coordinate(latitude: 53.0123, longitude: 9.0123),
                                      maximum: Coordinate(latitude: 54.987, longitude: 10.987))
        
        /// When
        manager.updateQuests(in: boundingBox, ignoreDownloadedQuestsBefore: Date())
        
        /// Then
        XCTAssertEqual(downloadedQuestTypesManagerMock.findDownloadedQuestTypesArguments?.tilesRect,
                       boundingBox.enclosingTilesRect(zoom: zoomForTiles))
    }
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldAskDownloadedQuestTypesManagerForDownloadedQuestTypesWithTheCorrectDate() {
        /// Given
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24)
        
        /// When
        manager.updateQuests(in: BoundingBox(minimum: Coordinate(latitude: 0, longitude: 0),
                                             maximum: Coordinate(latitude: 0, longitude: 0)),
                             ignoreDownloadedQuestsBefore: date)
        
        /// Then
        XCTAssertEqual(downloadedQuestTypesManagerMock.findDownloadedQuestTypesArguments?.date, date)
    }
    
    func testUpdateQuestsInBoundingBox_whenQuestTypeHasBeenDownloaded_shouldNotExecuteQuery() {
        /// Given
        let questType = "ExampleQuest"
        let questMock = OverpassQuestMock(type: questType)
        questProviderMock.quests = [questMock]
        
        downloadedQuestTypesManagerMock.findDownloadedQuestTypesReturnValue = [questType]
        
        /// When
        manager.updateQuests(in: BoundingBox(minimum: Coordinate(latitude: 0, longitude: 0),
                                             maximum: Coordinate(latitude: 0, longitude: 0)),
                             ignoreDownloadedQuestsBefore: Date())
        
        /// Then
        XCTAssertFalse(queryExecutorMock.didCallExecuteQuery)
    }
    
    func testUpdateQuestsInBoundingBox_whenQuestTypeHasNotYetBeenDownloaded_shouldExecuteQuery() {
        /// Given
        let questMock = OverpassQuestMock(type: "ExampleQuest")
        questProviderMock.quests = [questMock]
        
        downloadedQuestTypesManagerMock.findDownloadedQuestTypesReturnValue = []
        
        /// When
        manager.updateQuests(in: BoundingBox(minimum: Coordinate(latitude: 0, longitude: 0),
                                             maximum: Coordinate(latitude: 0, longitude: 0)),
                             ignoreDownloadedQuestsBefore: Date())
        
        /// Then
        XCTAssertTrue(queryExecutorMock.didCallExecuteQuery)
    }
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldAskQuestForQueryInBoundingBox() {
        /// Given
        let boundingBox = BoundingBox(minimum: Coordinate(latitude: 53.0123, longitude: 9.0123),
                                      maximum: Coordinate(latitude: 54.987, longitude: 10.987))
        
        let questMock = OverpassQuestMock(type: "ExampleQuest")
        
        questProviderMock.quests = [questMock]
        
        /// When
        manager.updateQuests(in: boundingBox,
                             ignoreDownloadedQuestsBefore: Date())
        
        /// Then
        XCTAssertEqual(questMock.queryBoundingBox, boundingBox)
    }
    
    func testUpdateQuestsInBoundingBox_whenCalled_shouldExecuteQueryOfNotDownloaded() {
        /// Given
        let typeOfDownloadedQuest = "FirstQuest"
        let firstQuestMock = OverpassQuestMock(type: typeOfDownloadedQuest)
        
        let secondQuestMock = OverpassQuestMock(type: "SecondQuest")
        secondQuestMock.queryToReturn = "lorem ipsum"
        
        questProviderMock.quests = [firstQuestMock, secondQuestMock]
        
        downloadedQuestTypesManagerMock.findDownloadedQuestTypesReturnValue = [typeOfDownloadedQuest]
        
        /// When
        manager.updateQuests(in: BoundingBox(minimum: Coordinate(latitude: 0, longitude: 0),
                                             maximum: Coordinate(latitude: 0, longitude: 0)),
                             ignoreDownloadedQuestsBefore: Date())
        
        /// Then
        XCTAssertEqual(queryExecutorMock.executeQueryArguments?.query, secondQuestMock.queryToReturn)
    }

}
