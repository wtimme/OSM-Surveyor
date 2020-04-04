//
//  OsmQuestDownloaderTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 04.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class OsmQuestDownloaderTestCase: XCTestCase {
    
    var downloader: OsmQuestDownloading!

    override func setUpWithError() throws {
        downloader = OsmQuestDownloader()
    }

    override func tearDownWithError() throws {
        downloader = nil
    }

}
