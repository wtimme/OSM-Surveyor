//
//  MapViewQuestDownloaderTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 01.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class MapViewQuestDownloaderTestCase: XCTestCase {
    
    var downloader: MapViewQuestDownloading!

    override func setUpWithError() throws {
        downloader = MapViewQuestDownloader()
    }

    override func tearDownWithError() throws {
        downloader = nil
    }

}
