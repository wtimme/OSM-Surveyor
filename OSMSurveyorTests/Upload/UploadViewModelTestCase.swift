//
//  UploadViewModelTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor

class UploadViewModelTestCase: XCTestCase {
    
    private var viewModel: UploadViewModel!

    override func setUpWithError() throws {
        viewModel = UploadViewModel(questId: 0)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

}
