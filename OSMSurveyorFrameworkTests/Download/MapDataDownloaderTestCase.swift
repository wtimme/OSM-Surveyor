//
//  MapDataDownloaderTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 28.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks
import XCTest

class MapDataDownloaderTestCase: XCTestCase {
    var downloader: MapDataDownloading!
    var questManagerMock: QuestManagerMock!

    override func setUpWithError() throws {
        questManagerMock = QuestManagerMock()

        setupDownloader()
    }

    override func tearDownWithError() throws {
        downloader = nil
        questManagerMock = nil
    }

    // MARK: calculateBoundingBox

    func testCalculateBoundingBox_whenBoundingBoxAreaIsLargerThanMaximumDownloadableArea_shouldThrowScreenAreaTooLargeError() {
        /// Given
        let germanyBoundingBox = BoundingBox(minimum: Coordinate(latitude: 5.98865807458,
                                                                 longitude: 47.3024876979),
                                             maximum: Coordinate(latitude: 15.0169958839,
                                                                 longitude: 54.983104153))

        setupDownloader(maximumDownloadableAreaInSquareKilometers: 1)

        /// Then
        XCTAssertThrowsError(try downloader.calculateBoundingBox(covering: germanyBoundingBox,
                                                                 cameraPosition: CameraPosition.makeCameraPosition())) { error in
            XCTAssertEqual(error as! MapDataDownloadError, MapDataDownloadError.screenAreaTooLarge)
        }
    }

    func testCalculateBoundingBox_whenBoundingBoxAreaTakingTileZoomIntoAccountIsLargerThanMaximumDownloadableArea_shouldThrowScreenAreaTooLargeError() {
        /// Given

        /// One single tile at zoom level 9 covers an area of about 2391 km².
        let areaInSquareMetersOfSingleTileAtZoomLevel9 = 2391.0

        /// This `BoundingBox` of London encloses about 93.86 km².
        let londonBoundingBox = BoundingBox(minimum: Coordinate(latitude: 51.55786291569685,
                                                                longitude: -0.1701164245605469),
                                            maximum: Coordinate(latitude: 51.4937822326078,
                                                                longitude: 0.02042770385742188))

        /// When using a tile zoom of 9, the area is covered by two tiles.
        /// That makes the area that *would* be downloaded larger than if the area was only covered by a single one.
        setupDownloader(maximumDownloadableAreaInSquareKilometers: areaInSquareMetersOfSingleTileAtZoomLevel9,
                        questTileZoom: 9)

        /// Then
        XCTAssertThrowsError(try downloader.calculateBoundingBox(covering: londonBoundingBox,
                                                                 cameraPosition: CameraPosition.makeCameraPosition())) { error in
            XCTAssertEqual(error as! MapDataDownloadError, MapDataDownloadError.screenAreaTooLarge)
        }
    }

    func testCalculateBoundingBox_whenBoundingBoxAreaTakingTileZoomIntoAccountIsSmallerThanMaximumDownloadableArea_shouldNotThrow() {
        /// Given

        /// One single tile at zoom level 9 covers an area of about 2391 km².
        let areaInSquareMetersOfSingleTileAtZoomLevel9 = 2391.0

        /// This `BoundingBox` of London encloses about 93.86 km².
        /// Note that it is different from the one used in the tests that assert a throw, making sure that the bounding box is covered by a single tile instead of two.
        let londonBoundingBox = BoundingBox(minimum: Coordinate(latitude: 51.55775618957977,
                                                                longitude: -0.21423339843750003),
                                            maximum: Coordinate(latitude: 51.4936753561844,
                                                                longitude: -0.023689270019531253))

        /// When using a tile zoom of 9, the area is covered by only one single tile.
        setupDownloader(maximumDownloadableAreaInSquareKilometers: areaInSquareMetersOfSingleTileAtZoomLevel9,
                        questTileZoom: 9)

        /// Then
        XCTAssertNoThrow(try downloader.calculateBoundingBox(covering: londonBoundingBox,
                                                             cameraPosition: CameraPosition.makeCameraPosition()))
    }

    func testCalculateBoundingBox_whenBoundingBoxAreaTakingTileZoomIntoAccountIsLargerThanMinimumDownloadArea_shouldReturnBoundingBoxFromTiles() {
        /// Given

        /// One single tile at zoom level 9 covers an area of about 2391 km².
        let areaInSquareMetersOfSingleTileAtZoomLevel9 = 2391.0

        /// Use a minimum area that is way smaller than the area that is covered by one tile.
        let minimumDownloadableAreaInSquareKilometers = 10.0

        /// Make sure that the maximum downloadable area is larger than the area that is covered by one tile.
        let maximumDownloadableAreaInSquareKilometers = areaInSquareMetersOfSingleTileAtZoomLevel9 * 2

        /// At zoom level 9, this `BoundingBox` of London bounding box is covered by a single tile.
        let londonBoundingBox = BoundingBox(minimum: Coordinate(latitude: 51.55775618957977,
                                                                longitude: -0.21423339843750003),
                                            maximum: Coordinate(latitude: 51.4936753561844,
                                                                longitude: -0.023689270019531253))

        /// When
        setupDownloader(minimumDownloadableAreaInSquareKilometers: minimumDownloadableAreaInSquareKilometers,
                        maximumDownloadableAreaInSquareKilometers: maximumDownloadableAreaInSquareKilometers,
                        questTileZoom: 9)
        let resultingBoundingBox = try? downloader.calculateBoundingBox(covering: londonBoundingBox,
                                                                        cameraPosition: CameraPosition.makeCameraPosition())

        /// Then
        let boundingBoxOfEnclosingTiles = londonBoundingBox.asBoundingBoxOfEnclosingTiles(zoom: 9)

        XCTAssertEqual(resultingBoundingBox, boundingBoxOfEnclosingTiles)
    }

    func testCalculateBoundingBox_whenBoundingBoxAreaTakingTileZoomIntoAccountIsSmallerThanMinimumDownloadArea_shouldUseCameraToCalculateBoundingBox() {
        /// Given

        /// When covered with tiles at zoom level 18, this `BoundingBox` of Berlin has a size of about 0.155 km².
        let berlinBoundingBox = BoundingBox(minimum: Coordinate(latitude: 52.515505944488055,
                                                                longitude: 13.375715017318726),
                                            maximum: Coordinate(latitude: 52.517464600171216,
                                                                longitude: 13.381669521331789))

        /// Use a minimum area that is smaller than the area covered by the Berlin bounding box above.
        let minimumDownloadableAreaInSquareKilometers = 0.16

        /// The camera is centered on the "Brandenburger Tor" in Berlin, which is the center of above's bounding box.
        let cameraCenterCoordinate = Coordinate(latitude: 52.39952, longitude: 13.04816)

        let minimumDownloadRadiusInMeters = 1000.0

        /// When
        setupDownloader(minimumDownloadableAreaInSquareKilometers: minimumDownloadableAreaInSquareKilometers,
                        questTileZoom: 18,
                        minimumDownloadRadiusInMeters: minimumDownloadRadiusInMeters)
        let resultingBoundingBox = try? downloader.calculateBoundingBox(covering: berlinBoundingBox,
                                                                        cameraPosition: CameraPosition.makeCameraPosition(center: cameraCenterCoordinate))

        /// Then
        let boundingBoxAroundCameraCenter = cameraCenterCoordinate.enclosingBoundingBox(radius: minimumDownloadRadiusInMeters)
        XCTAssertEqual(resultingBoundingBox, boundingBoxAroundCameraCenter)
    }

    // MARK: Helper methods

    private func setupDownloader(minimumDownloadableAreaInSquareKilometers: Double = 1,
                                 maximumDownloadableAreaInSquareKilometers: Double = 20,
                                 questTileZoom: Int = 14,
                                 minimumDownloadRadiusInMeters: Double = 600)
    {
        downloader = MapDataDownloader(questManager: questManagerMock,
                                       questTileZoom: questTileZoom,
                                       minimumDownloadableAreaInSquareKilometers: minimumDownloadableAreaInSquareKilometers,
                                       maximumDownloadableAreaInSquareKilometers: maximumDownloadableAreaInSquareKilometers,
                                       minimumDownloadRadiusInMeters: minimumDownloadRadiusInMeters)
    }
}
