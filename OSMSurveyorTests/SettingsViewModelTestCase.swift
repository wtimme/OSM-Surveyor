//
//  SettingsViewModelTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyor
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks
import XCTest

class SettingsViewModelTestCase: XCTestCase {
    var viewModel: SettingsViewModel!
    var keychainHandlerMock: KeychainHandlerMock!
    var notificationCenter: NotificationCenter!
    var coordinatorMock: SettingsCoordinatorMock!
    var delegateMock: SettingsViewModelDelegateMock!

    override func setUpWithError() throws {
        keychainHandlerMock = KeychainHandlerMock()
        notificationCenter = NotificationCenter()
        coordinatorMock = SettingsCoordinatorMock()
        delegateMock = SettingsViewModelDelegateMock()

        recreateViewModel()
    }

    override func tearDownWithError() throws {
        keychainHandlerMock = nil
        notificationCenter = nil
        viewModel = nil
        coordinatorMock = nil
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
        let accountSection = 0
        let headerTitle = viewModel.headerTitleOfSection(accountSection)

        XCTAssertEqual(headerTitle, "OpenStreetMap Accounts")
    }

    func testNumberOfRowsInSection_whenAskedAboutAccountSectionAndThereAreNoAccounts_shouldReturnOne() {
        keychainHandlerMock.entries = []

        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()

        let accountSection = 0
        let numberOfRows = viewModel.numberOfRows(in: accountSection)

        XCTAssertEqual(numberOfRows, 1)
    }

    func testNumberOfRowsInSection_whenAskedAboutAccountSectionAndThereAreAccounts_shouldNumberOfAccountsPlusOne() {
        let numberOfAccounts = 42
        keychainHandlerMock.entries = (1 ... numberOfAccounts).map {
            let credentials = OAuth1Credentials(token: "", tokenSecret: "")

            return (username: "User #\($0)", credentials: credentials)
        }

        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()

        let accountSection = 0
        let numberOfRows = viewModel.numberOfRows(in: accountSection)

        XCTAssertEqual(numberOfRows, numberOfAccounts + 1)
    }

    func testRowAtIndexPath_forAllRowsInAccountSectionOtherThanTheLastOne_shouldUseUsernameAsTitle() {
        let accountSection = 0

        let username = "jane.doe"
        keychainHandlerMock.entries = [(username: username, credentials: OAuth1Credentials(token: "", tokenSecret: ""))]

        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()

        let row = viewModel.row(at: IndexPath(row: 0, section: accountSection))

        XCTAssertEqual(row?.title, username)
        XCTAssertEqual(row?.accessoryType, .disclosureIndicator)
    }

    func testSelectRow_forAllRowsInAccountSectionOtherThanTheLastOne_shouldTellCoordinatorToAskForConfirmationToRemoveAccount() {
        let accountSection = 0

        let username = "jane.doe"
        keychainHandlerMock.entries = [(username: username, credentials: OAuth1Credentials(token: "", tokenSecret: ""))]

        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()

        /// When
        viewModel.selectRow(at: IndexPath(row: 0, section: accountSection))

        XCTAssertTrue(coordinatorMock.didCallAskForConfirmationToRemoveAccount)
        XCTAssertEqual(coordinatorMock.askForConfirmationToRemoveAccountArguments?.username, username)
    }

    func testSelectRow_afterConfirmingRemovalOfAccount_shouldAskKeychainHandlerToRemoveAccount() {
        let accountSection = 0

        let username = "jane.doe"
        keychainHandlerMock.entries = [(username: username, credentials: OAuth1Credentials(token: "", tokenSecret: ""))]

        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()

        /// When
        viewModel.selectRow(at: IndexPath(row: 0, section: accountSection))
        coordinatorMock.askForConfirmationToRemoveAccountArguments?.confirm()

        /// Then
        XCTAssertTrue(keychainHandlerMock.didCallRemove)
        XCTAssertEqual(keychainHandlerMock.usernameToRemove, username)
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

    func test_whenReceivingKeychainDidChangeNumberOfEntriesNotification_shouldAskDelegateToReloadAccountSection() {
        /// Given
        let accountSection = 0

        notificationCenter.post(name: .keychainHandlerDidChangeNumberOfEntries, object: nil)

        XCTAssertTrue(delegateMock.didCallReloadReloadSection)
        XCTAssertEqual(delegateMock.sectionToReload, accountSection)
    }

    func test_whenReceivingKeychainDidChangeNumberOfEntriesNotification_shouldUpdateAccountSectionRows() {
        /// Given
        let accountSection = 0

        /// At the beginning, the Keychain handler only has one single entry
        keychainHandlerMock.entries = [(username: "", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]

        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()

        /// Now, the Keychain handler reports two entries
        keychainHandlerMock.entries = [(username: "", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]

        notificationCenter.post(name: .keychainHandlerDidChangeNumberOfEntries, object: nil)

        XCTAssertEqual(viewModel.numberOfRows(in: accountSection), keychainHandlerMock.entries.count + 1,
                       "The account section should now contain three rows: two accounts and 'Add Account'")
    }

    // MARK: Help Section

    func testNumberOfRowsInSection_whenAskedAboutLastSection_shouldReturnExpectedNumber() {
        let lastSection = viewModel.numberOfSections() - 1
        let numberOfRows = viewModel.numberOfRows(in: lastSection)

        XCTAssertEqual(numberOfRows, 3)
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

    func testRowAtIndexPath_forThirdRowInLastSection_shouldReturnPrivacyStatement() {
        let lastSection = viewModel.numberOfSections() - 1

        XCTAssertEqual(viewModel.row(at: IndexPath(item: 2, section: lastSection))?.title,
                       "Privacy Statement")
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
        let newViewModel = SettingsViewModel(keychainHandler: keychainHandlerMock,
                                             notificationCenter: notificationCenter,
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

    func testSelectRow_whenTappingThirdRowInHelpSection_shouldAskCoordinatorToPresentPrivacyStatement() {
        /// Given
        let lastSection = viewModel.numberOfSections() - 1

        /// When
        viewModel.selectRow(at: IndexPath(row: 2, section: lastSection))

        /// Then
        XCTAssertTrue(coordinatorMock.didCallPresentPrivacyStatement)
    }

    // MARK: Helper methods

    private func recreateViewModel() {
        viewModel = SettingsViewModel(keychainHandler: keychainHandlerMock,
                                      notificationCenter: notificationCenter,
                                      appName: "",
                                      appVersion: "",
                                      appBuildNumber: "")

        viewModel.coordinator = coordinatorMock
        viewModel.delegate = delegateMock
    }
}
