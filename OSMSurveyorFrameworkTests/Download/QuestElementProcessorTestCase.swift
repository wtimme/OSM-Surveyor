//
//  QuestElementProcessorTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
import XCTest

class QuestElementProcessorTestCase: XCTestCase {
    private let zoomForTiles = 42

    var processor: QuestElementProcessing!
    var downloadedQuestTypesManagerMock: DownloadedQuestTypesManagerMock!
    var questDataManagerMock: QuestDataManagerMock!
    var elementGeometryDataManagerMock: ElementGeometryDataManagerMock!
    var nodeDataManagerMock: NodeDataManagerMock!

    override func setUpWithError() throws {
        downloadedQuestTypesManagerMock = DownloadedQuestTypesManagerMock()
        questDataManagerMock = QuestDataManagerMock()
        elementGeometryDataManagerMock = ElementGeometryDataManagerMock()
        nodeDataManagerMock = NodeDataManagerMock()

        processor = QuestElementProcessor(zoomForDownloadedTiles: zoomForTiles,
                                          downloadedQuestTypesManager: downloadedQuestTypesManagerMock,
                                          questDataManager: questDataManagerMock,
                                          elementGeometryDataManager: elementGeometryDataManagerMock,
                                          nodeDataManager: nodeDataManagerMock)
    }

    override func tearDownWithError() throws {
        processor = nil
        downloadedQuestTypesManagerMock = nil
        questDataManagerMock = nil
        elementGeometryDataManagerMock = nil
        nodeDataManagerMock = nil
    }

    func testProcess_shouldMarkQuestTypeAsDownloaded() {
        /// Given
        let questType = "LoremIpsum"
        let boundingBox = BoundingBox.makeBoundingBox()

        /// When
        processor.processElements([],
                                  in: boundingBox,
                                  forQuestOfType: questType)

        /// Then
        XCTAssertTrue(downloadedQuestTypesManagerMock.didCallMarkQuestTypeAsDownloaded)
        XCTAssertEqual(downloadedQuestTypesManagerMock.markQuestTypeAsDownloadedArguments?.questType, questType)
        XCTAssertEqual(downloadedQuestTypesManagerMock.markQuestTypeAsDownloadedArguments?.tilesRect,
                       boundingBox.enclosingTilesRect(zoom: zoomForTiles))
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
        XCTAssertFalse(elementGeometryDataManagerMock.didCallInsert)
        XCTAssertFalse(nodeDataManagerMock.didCallInsert)
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

    func testProcess_whenBothElementAndGeometryArePresent_shouldInsertGeometryIntoDatabase() {
        /// Given
        let elementType = ElementGeometry.ElementType.node
        let elementId = 165
        let polylines: [ElementGeometry.Polyline]? = nil
        let polygons: [ElementGeometry.Polygon]? = nil
        let center = Coordinate(latitude: 1, longitude: 2)

        let element: Element = Node.makeNode(id: elementId)
        let elementGeometry: ElementGeometry? = ElementGeometry(type: elementType,
                                                                elementId: elementId,
                                                                polylines: polylines,
                                                                polygons: polygons,
                                                                center: center)

        /// When
        processor.processElements([(element, elementGeometry)],
                                  in: BoundingBox.makeBoundingBox(),
                                  forQuestOfType: "")

        /// Then
        XCTAssertTrue(elementGeometryDataManagerMock.didCallInsert)
        XCTAssertEqual(elementGeometryDataManagerMock.insertElement, elementGeometry)
    }

    func testProcess_whenBothElementAndGeometryArePresent_shouldInsertNodeIntoDatabase() {
        /// Given
        let element = Node.makeNode()

        /// When
        processor.processElements([(element, ElementGeometry.makeGeometry())],
                                  in: BoundingBox.makeBoundingBox(),
                                  forQuestOfType: "")

        /// Then
        XCTAssertTrue(nodeDataManagerMock.didCallInsert)
        XCTAssertEqual(nodeDataManagerMock.insertElement, element)
    }
}
