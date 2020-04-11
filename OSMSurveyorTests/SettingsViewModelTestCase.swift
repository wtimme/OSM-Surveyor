//
//  SettingsViewModelTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor

class SettingsViewModelTestCase: XCTestCase {
    
    var viewModel: SettingsViewModel!

    override func setUpWithError() throws {
        viewModel = SettingsViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
}
