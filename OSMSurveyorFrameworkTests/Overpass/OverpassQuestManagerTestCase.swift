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
    
    private var manager: OverpassQuestManager!
    private var downloadedQuestTypesManagerMock: DownloadedQuestTypesManagerMock!

    override func setUpWithError() throws {
        downloadedQuestTypesManagerMock = DownloadedQuestTypesManagerMock()
        
        manager = OverpassQuestManager(downloadedQuestTypesManager: downloadedQuestTypesManagerMock)
    }

    override func tearDownWithError() throws {
        manager = nil
        downloadedQuestTypesManagerMock = nil
    }

}
