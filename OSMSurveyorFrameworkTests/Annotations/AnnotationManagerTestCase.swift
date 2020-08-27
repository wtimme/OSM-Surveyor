//
//  AnnotationManagerTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
import XCTest

class AnnotationManagerTestCase: XCTestCase {
    private let zoomForTiles = 10

    private var manager: AnnotationManaging!
    private var fullQuestsDataProviderMock: FullQuestsDataProviderMock!

    private var delegateMock: AnnotationManagerDelegateMock!

    override func setUpWithError() throws {
        fullQuestsDataProviderMock = FullQuestsDataProviderMock()

        manager = AnnotationManager(zoomForDownloadedTiles: zoomForTiles,
                                    fullQuestsDataProvider: fullQuestsDataProviderMock)

        delegateMock = AnnotationManagerDelegateMock()
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
        let boundingBox = BoundingBox.makeBoundingBox(minimum: Coordinate(latitude: 53.55546, longitude: 9.98903),
                                                      maximum: Coordinate(latitude: 53.55556, longitude: 9.98913))

        /// When
        manager.mapDidUpdatePosition(to: boundingBox)

        /// Then
        XCTAssertTrue(fullQuestsDataProviderMock.didCallFindQuests)
        XCTAssertEqual(fullQuestsDataProviderMock.findQuestsBoundingBox,
                       boundingBox.asBoundingBoxOfEnclosingTiles(zoom: zoomForTiles))
    }

    func testMapDidUpdateBoundingBox_whenNoQuestsWereFound_shouldNotAskDelegateToSetAnnotations() {
        /// Given
        fullQuestsDataProviderMock.questsToReturn = []

        /// When
        manager.mapDidUpdatePosition(to: BoundingBox.makeBoundingBox())

        /// Then
        XCTAssertFalse(delegateMock.didCallSetAnnotations)
    }

    func testMapDidUpdateBoundingBox_whenQuestsWereFound_shouldAskDelegateToSetAnnotations() {
        /// Given
        let boundingBox = BoundingBox.makeBoundingBox(minimum: Coordinate(latitude: 53.55546, longitude: 9.98903),
                                                      maximum: Coordinate(latitude: 53.55556, longitude: 9.98913))

        let firstCoordinate = Coordinate(latitude: 1, longitude: 1)
        let secondCoordinate = Coordinate(latitude: 2, longitude: 2)
        let thirdCoordinate = Coordinate(latitude: 3, longitude: 3)

        fullQuestsDataProviderMock.questsToReturn = [(firstCoordinate, "AddBenchBackrest", 1),
                                                     (secondCoordinate, "AddBusStopShelter", 2),
                                                     (thirdCoordinate, "AddBenchBackrest", 3)]

        /// When
        manager.mapDidUpdatePosition(to: boundingBox)

        /// Then
        XCTAssertTrue(delegateMock.didCallSetAnnotations)

        let expectedAnnotations = [
            Annotation(coordinate: firstCoordinate, questType: "AddBenchBackrest", questId: 1),
            Annotation(coordinate: secondCoordinate, questType: "AddBusStopShelter", questId: 2),
            Annotation(coordinate: thirdCoordinate, questType: "AddBenchBackrest", questId: 3),
        ]
        XCTAssertEqual(delegateMock.annotations, expectedAnnotations)
    }

    func testMapDidUpdateBoundingBox_whenQuestsWereFound_shouldAskDelegateToSetAllAnnotations() {
        /// Given
        let firstCoordinate = Coordinate(latitude: 1, longitude: 1)
        let secondCoordinate = Coordinate(latitude: 2, longitude: 2)

        fullQuestsDataProviderMock.questsToReturn = [(firstCoordinate, "AddBenchBackrest", 1),
                                                     (secondCoordinate, "AddBusStopShelter", 2)]

        /// Update position for the first time.
        let firstBoundingBox = BoundingBox.makeBoundingBox(minimum: Coordinate(latitude: 53.55546, longitude: 9.98903),
                                                           maximum: Coordinate(latitude: 53.55556, longitude: 9.98913))
        manager.mapDidUpdatePosition(to: firstBoundingBox)

        /// Now, act as if new quests were found.
        let thirdCoordinate = Coordinate(latitude: 2, longitude: 2)
        fullQuestsDataProviderMock.questsToReturn = [(thirdCoordinate, "AddBenchBackrest", 3)]

        /// Update position for a second time.
        let secondBoundingBox = BoundingBox.makeBoundingBox(minimum: Coordinate(latitude: 54.55546, longitude: 10.98903),
                                                            maximum: Coordinate(latitude: 54.55556, longitude: 10.98913))

        manager.mapDidUpdatePosition(to: secondBoundingBox)

        /// Then
        XCTAssertTrue(delegateMock.didCallSetAnnotations)

        let expectedAnnotations = [
            Annotation(coordinate: firstCoordinate, questType: "AddBenchBackrest", questId: 1),
            Annotation(coordinate: secondCoordinate, questType: "AddBusStopShelter", questId: 2),
            Annotation(coordinate: thirdCoordinate, questType: "AddBenchBackrest", questId: 3),
        ]
        XCTAssertEqual(delegateMock.annotations, expectedAnnotations)
    }

    func testMapDidUpdateBoundingBox_whenTheAnnotationsForBoundingBoxHaveAlreadyBeenRetrieved_shouldNotAskQuestDataProviderToProvideQuests() {
        /// Given
        let boundingBox = BoundingBox.makeBoundingBox(minimum: Coordinate(latitude: 53.55546, longitude: 9.98903),
                                                      maximum: Coordinate(latitude: 53.55556, longitude: 9.98913))

        /// When
        manager.mapDidUpdatePosition(to: boundingBox)
        manager.mapDidUpdatePosition(to: boundingBox)

        /// Then
        XCTAssertEqual(fullQuestsDataProviderMock.findQuestsCallCounter, 1)
    }
}
