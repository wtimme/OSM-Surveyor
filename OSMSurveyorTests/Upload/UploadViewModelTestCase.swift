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
    var delegateMock: TableViewModelDelegateMock!

    override func setUpWithError() throws {
        viewModel = UploadViewModel(questId: 0)
        
        delegateMock = TableViewModelDelegateMock()
        viewModel.delegate = delegateMock
    }

    override func tearDownWithError() throws {
        viewModel = nil
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

}
