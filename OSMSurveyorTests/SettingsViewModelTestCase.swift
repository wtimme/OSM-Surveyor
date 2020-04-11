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
    
    func testNumberOfRowsInSection_whenProvidedWithInvalidSection_shouldReturnZero() {
        XCTAssertEqual(viewModel.numberOfRows(in: 9999), 0)
        XCTAssertEqual(viewModel.numberOfRows(in: -5), 0)
    }
    
    // MARK: Help Section
    
    func testNumberOfRowsInSection_whenAskedAboutLastSection_shouldReturnExpectedNumber() {
        let lastSection = viewModel.numberOfSections() - 1
        let numberOfRows = viewModel.numberOfRows(in: lastSection)
        
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testLastSectionShouldHaveHelpAsHeaderTitle() {
        let lastSection = viewModel.numberOfSections() - 1
        
        XCTAssertEqual(viewModel.headerTitleOfSection(lastSection), "Help")
    }
    
    func testLastSectionShouldHaveAppDetailsAsFooterTitle() {
        /// Given
        let appName = "Lorem Ipsum"
        let appVersion = "42"
        let appBuildNumber = "999"
        
        /// When
        let newViewModel = SettingsViewModel(appName: appName,
                                             appVersion: appVersion,
                                             appBuildNumber: appBuildNumber)
        
        /// Then
        XCTAssertEqual(newViewModel.sections.last?.footerTitle, "\(appName) \(appVersion) (Build \(appBuildNumber))")
    }
    
}
