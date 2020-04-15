//
//  UploadViewModelTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFramework
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
    
    func testNumberOfRowsInSection_whenAskedAboutAccountSectionAndThereAreNoAccounts_shouldReturnOne() {
        keychainHandlerMock.entries = []
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        let numberOfRows = viewModel.numberOfRows(in: accountSection)
        
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRowsInSection_whenAskedAboutAccountSectionAndThereAreAccounts_shouldNumberOfAccountsPlusOne() {
        let numberOfAccounts = 42
        keychainHandlerMock.entries = (1...numberOfAccounts).map {
            let credentials = OAuth1Credentials(token: "", tokenSecret: "")
            
            return (username: "User #\($0)", credentials: credentials)
        }
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        let numberOfRows = viewModel.numberOfRows(in: accountSection)
        
        XCTAssertEqual(numberOfRows, numberOfAccounts + 1)
    }
    
    func testRowAtIndexPath_forAllRowsInAccountSectionOtherThanTheLastOne_shouldUseUsernameAsTitle() {
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        let username = "jane.doe"
        keychainHandlerMock.entries = [(username: username, credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        let row = viewModel.row(at: IndexPath(row: 0, section: accountSection))
        
        XCTAssertEqual(row?.title, username)
    }
    
    func testRowAtIndexPath_forFirstRowWithAnActualAccount_shouldUseCheckmarkAsAccessoryType() {
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "lorem.ipsum", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        let row = viewModel.row(at: IndexPath(row: 0, section: accountSection))
        
        XCTAssertEqual(row?.accessoryType, .checkmark)
    }
    
    func testRowAtIndexPath_forAllActualAccountsButTheFirst_shouldUseNoneAsAccessoryType() {
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "lorem.ipsum", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "foo.bar", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        let secondAccountRow = viewModel.row(at: IndexPath(row: 1, section: accountSection))
        XCTAssertEqual(secondAccountRow?.accessoryType, Table.Row.AccessoryType.none)
        
        let thirdAccountRow = viewModel.row(at: IndexPath(row: 2, section: accountSection))
        XCTAssertEqual(thirdAccountRow?.accessoryType, Table.Row.AccessoryType.none)
    }
    
    func testRowAtIndexPath_forLastRowInAccountSection_shouldReturnAddAccount() {
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        let indexOfLastRow = viewModel.numberOfRows(in: accountSection) - 1
        let row = viewModel.row(at: IndexPath(row: indexOfLastRow, section: accountSection))
        
        XCTAssertEqual(row?.title, "Add Account")
        XCTAssertEqual(row?.accessoryType, .disclosureIndicator)
    }
    
    // MARK: Helper methods
    
    private func recreateViewModel(questId: Int = 0) {
        viewModel = UploadViewModel(keychainHandler: keychainHandlerMock,
                                    questId: questId)
        
        viewModel.delegate = delegateMock
    }

}
