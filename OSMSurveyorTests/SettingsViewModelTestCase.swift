//
//  SettingsViewModelTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks

class SettingsViewModelTestCase: XCTestCase {
    
    var viewModel: SettingsViewModel!
    var accountHandlerMock: AccountHandlerMock!
    var coordinatorMock: SettingsCoordinatorMock!

    override func setUpWithError() throws {
        accountHandlerMock = AccountHandlerMock()
        viewModel = SettingsViewModel()
        
        coordinatorMock = SettingsCoordinatorMock()
        viewModel.coordinator = coordinatorMock
    }

    override func tearDownWithError() throws {
        accountHandlerMock = nil
        viewModel = nil
        coordinatorMock = nil
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
        let accountSection = 0
        let headerTitle = viewModel.headerTitleOfSection(accountSection)
        
        XCTAssertEqual(headerTitle, "OpenStreetMap Accounts")
    }
    
    func testNumberOfRowsInSection_whenAskedAboutAccountSectionAndThereAreNoAccounts_shouldReturnOne() {
        accountHandlerMock.accounts = []
        
        let accountSection = 0
        let numberOfRows = viewModel.numberOfRows(in: accountSection)
        
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRowsInSection_whenAskedAboutAccountSectionAndThereAreAccounts_shouldNumberOfAccountsPlusOne() {
        let numberOfAccounts = 42
        accountHandlerMock.accounts = (1...numberOfAccounts).map { Account.makeAccount(username: "User #\($0)") }
        
        /// Re-generate the view model, since the account handler's accounts are retrieved during initialization.
        viewModel = SettingsViewModel(accountHandler: accountHandlerMock,
                                      appName: "",
                                      appVersion: "",
                                      appBuildNumber: "")
        
        let accountSection = 0
        let numberOfRows = viewModel.numberOfRows(in: accountSection)
        
        XCTAssertEqual(numberOfRows, numberOfAccounts + 1)
    }
    
    func testRowAtIndexPath_forAllRowsInAccountSectionOtherThanTheLastOne_shouldUseUsernameAsTitle() {
        let accountSection = 0
        
        let username = "jane.doe"
        accountHandlerMock.accounts = [Account.makeAccount(username: username)]
        
        /// Re-generate the view model, since the account handler's accounts are retrieved during initialization.
        viewModel = SettingsViewModel(accountHandler: accountHandlerMock,
                                      appName: "",
                                      appVersion: "",
                                      appBuildNumber: "")
        
        let row = viewModel.row(at: IndexPath(row: 0, section: accountSection))
        
        XCTAssertEqual(row?.title, username)
        XCTAssertEqual(row?.accessoryType, .disclosureIndicator)
    }
    
    func testRowAtIndexPath_forLastRowInAccountSection_shouldReturnAddAccount() {
        let accountSection = 0
        let indexOfLastRow = viewModel.numberOfRows(in: accountSection) - 1
        let row = viewModel.row(at: IndexPath(row: indexOfLastRow, section: accountSection))
        
        XCTAssertEqual(row?.title, "Add Account")
        XCTAssertEqual(row?.accessoryType, .disclosureIndicator)
    }
    
    func testSelectRow_whenTappingLastRowInAccountSection_shouldAskCoordinatorToStartAddAccountFlow() {
        /// Given
        let accountSection = 0
        let indexOfLastRow = viewModel.numberOfRows(in: accountSection) - 1
        
        /// When
        viewModel.selectRow(at: IndexPath(row: indexOfLastRow, section: accountSection))
        
        /// Then
        XCTAssertTrue(coordinatorMock.didCallStartAddAccountFlow)
    }
    
    // MARK: Help Section
    
    func testNumberOfRowsInSection_whenAskedAboutLastSection_shouldReturnExpectedNumber() {
        let lastSection = viewModel.numberOfSections() - 1
        let numberOfRows = viewModel.numberOfRows(in: lastSection)
        
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testRowAtIndexPath_forFirstRowInLastSection_shouldReturnGitHubRepository() {
        let lastSection = viewModel.numberOfSections() - 1
        
        XCTAssertEqual(viewModel.row(at: IndexPath(item: 0, section: lastSection))?.title,
                       "GitHub Repository")
    }
    
    func testRowAtIndexPath_forSecondRowInLastSection_shouldReturnBugTracker() {
        let lastSection = viewModel.numberOfSections() - 1
        
        XCTAssertEqual(viewModel.row(at: IndexPath(item: 1, section: lastSection))?.title,
                       "Bug Tracker")
    }
    
    func testLastSectionShouldHaveHelpAsHeaderTitle() {
        let lastSection = viewModel.numberOfSections() - 1
        
        XCTAssertEqual(viewModel.headerTitleOfSection(lastSection), "Help")
    }
    
    func testLastSectionShouldHaveAppDetailsAsFooterTitle() {
        let lastSection = viewModel.numberOfSections() - 1
        
        /// Given
        let appName = "Lorem Ipsum"
        let appVersion = "42"
        let appBuildNumber = "999"
        
        /// When
        let newViewModel = SettingsViewModel(accountHandler: accountHandlerMock,
                                             appName: appName,
                                             appVersion: appVersion,
                                             appBuildNumber: appBuildNumber)
        
        /// Then
        XCTAssertEqual(newViewModel.footerTitleOfSection(lastSection),
                       "\(appName) \(appVersion) (Build \(appBuildNumber))")
    }
    
    func testSelectRow_whenTappingFirstRowInHelpSection_shouldAskCoordinatorToPresentGitHubRepository() {
        /// Given
        let lastSection = viewModel.numberOfSections() - 1
        
        /// When
        viewModel.selectRow(at: IndexPath(row: 0, section: lastSection))
        
        /// Then
        XCTAssertTrue(coordinatorMock.didCallPresentGitHubRepository)
    }
    
    func testSelectRow_whenTappingSecondRowInHelpSection_shouldAskCoordinatorToPresentBugTracker() {
        /// Given
        let lastSection = viewModel.numberOfSections() - 1
        
        /// When
        viewModel.selectRow(at: IndexPath(row: 1, section: lastSection))
        
        /// Then
        XCTAssertTrue(coordinatorMock.didCallPresentBugTracker)
    }
    
}
