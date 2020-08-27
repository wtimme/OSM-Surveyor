//
//  SlippyMapMathTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
import XCTest

/// The values and test cases are taken directly from StreetComplete.
/// Source: https://github.com/westnordost/StreetComplete/blob/master/app/src/test/java/de/westnordost/streetcomplete/util/SlippyMapMathTest.kt
class SlippyMapMathTestCase: XCTestCase {
    func test_convertBoundingBoxToTilesRectAndBack_shouldResultInSameBoundingBox() {
        let zoom = 15

        let point = Coordinate(latitude: 53, longitude: 9)
        let tile = point.enclosingTile(zoom: zoom)
        let boundingBox = tile.asBoundingBox(zoom: zoom)

        XCTAssertTrue(boundingBox.minimum.latitude <= point.latitude)
        XCTAssertTrue(boundingBox.maximum.latitude >= point.latitude)
        XCTAssertTrue(boundingBox.minimum.longitude <= point.longitude)
        XCTAssertTrue(boundingBox.maximum.longitude >= point.longitude)

        let tilesRect = boundingBox.enclosingTilesRect(zoom: zoom)
        let boundingBoxFromTilesRect = tilesRect.asBoundingBox(zoom: zoom)
        XCTAssertEqual(boundingBox, boundingBoxFromTilesRect)
    }

    func test_enclosingTilesRectOfBoundingBox() {
        let boundingBox = BoundingBox(minimum: Coordinate(latitude: 10, longitude: 170),
                                      maximum: Coordinate(latitude: 20, longitude: -170))

        let tilesRect = boundingBox.enclosingTilesRect(zoom: 4)

        /// A `TilesRect` that is initialized crossing 180th meridian would contain (0, 0, 0, 0)
        XCTAssertNotEqual(tilesRect, TilesRect(left: 0, top: 0, right: 0, bottom: 0))
    }

    func testTilesRectAsTiles_shouldReturnListOfContainedTiles() {
        let tilesRect = TilesRect(left: 1, top: 1, right: 2, bottom: 2)
        let tiles = tilesRect.tiles()

        XCTAssertEqual(tiles, [
            Tile(x: 1, y: 1),
            Tile(x: 2, y: 1),
            Tile(x: 1, y: 2),
            Tile(x: 2, y: 2),
        ])
    }

    func testMinTileRect() {
        let emptyTileList: [Tile] = []

        XCTAssertNil(emptyTileList.minTileRect())
    }

    func testMinTileRect_whenListHasOnlyOneEntry_shouldReturnTileRectOfSize1() {
        let tileList: [Tile] = [Tile(x: 1, y: 1)]

        XCTAssertEqual(tileList.minTileRect(), TilesRect(left: 1, top: 1, right: 1, bottom: 1))
    }

    func testMinTileRect_shouldReturnCorrectMinimumTileRect() {
        let tileList: [Tile] = [Tile(x: 5, y: 8),
                                Tile(x: 3, y: 2),
                                Tile(x: 6, y: 15),
                                Tile(x: 32, y: 12)]

        XCTAssertEqual(tileList.minTileRect(), TilesRect(left: 3, top: 2, right: 32, bottom: 15))
    }

    func testTilesRectSize_shouldReturnCorrectSize() {
        XCTAssertEqual(TilesRect(left: 0, top: 0, right: 3, bottom: 2).size, 12)
    }
}
