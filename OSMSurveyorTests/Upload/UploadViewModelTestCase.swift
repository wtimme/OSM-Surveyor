//
//  UploadViewModelTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFrameworkMocks

class UploadViewModelTestCase: XCTestCase {
    
    private var viewModel: UploadViewModel!
    private var delegateMock: TableViewModelDelegateMock!
    private var keychainHandlerMock: KeychainHandlerMock!

    override func setUpWithError() throws {
        keychainHandlerMock = KeychainHandlerMock()
        delegateMock = TableViewModelDelegateMock()
        
        recreateViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        keychainHandlerMock = nil
        delegateMock = nil
    }
    
    func testNumberOfRowsInSection_whenProvidedWithInvalidSection_shouldReturnZero() {
        XCTAssertEqual(viewModel.numberOfRows(in: 9999), 0)
        XCTAssertEqual(viewModel.numberOfRows(in: -5), 0)
    }
    
    func testRowAtIndexPath_whenProvidedWithInvalidIndexPath_shouldReturnNil() {
        XCTAssertNil(viewModel.row(at: IndexPath(item: 23, section: -1)))
        XCTAssertNil(viewModel.row(at: IndexPath(item: -101, section: 42)))
    }
    
    // MARK: Accounts section
    
    func testHeaderTitle_whenAskedAboutAccountSection_shouldReturnExpectedTitle() {
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        let headerTitle = viewModel.headerTitleOfSection(accountSection)
        
        XCTAssertEqual(headerTitle, "Select account")
    }
    
    // MARK: Helper methods
    
    private func recreateViewModel(questId: Int = 0) {
        viewModel = UploadViewModel(questId: questId)
        
        viewModel.delegate = delegateMock
    }

}
