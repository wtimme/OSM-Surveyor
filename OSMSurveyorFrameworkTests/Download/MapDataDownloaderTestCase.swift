//
//  MapDataDownloaderTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 28.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
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

    // MARK: Helper methods

    private func setupDownloader(maximumDownloadableAreaInSquareKilometers: Double = 20,
                                 questTileZoom: Int = 14)
    {
        downloader = MapDataDownloader(questManager: questManagerMock,
                                       questTileZoom: questTileZoom,
                                       maximumDownloadableAreaInSquareKilometers: maximumDownloadableAreaInSquareKilometers)
    }
}
