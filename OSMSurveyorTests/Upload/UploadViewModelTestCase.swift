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
    private var notificationCenter: NotificationCenter!
    private var userDefaults: UserDefaults!
    private let selectedUsernameUserDefaultsKey = "lorem_ipsum_dolor"
    private var coordinatorMock: UploadFlowCoordinatorMock!

    override func setUpWithError() throws {
        keychainHandlerMock = KeychainHandlerMock()
        notificationCenter = NotificationCenter()
        coordinatorMock = UploadFlowCoordinatorMock()
        delegateMock = TableViewModelDelegateMock()
        
        /// Create a unique `UserDefaults` instance.
        userDefaults = UserDefaults(suiteName: UUID().uuidString)
        
        recreateViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        keychainHandlerMock = nil
        notificationCenter = nil
        userDefaults = nil
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
    
    func testRowAtIndexPath_whenNoUsernameMatchesTheSelectedOneStoredInUserDefaults_shouldUseCheckmarkAsAccessoryTypeForTheFirstRow() {
        /// Given
        userDefaults.set("something random", forKey: selectedUsernameUserDefaultsKey)
        
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "lorem.ipsum", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries and the `UserDefaults` values are retrieved during initialization.
        recreateViewModel()
        
        XCTAssertEqual(viewModel.row(at: IndexPath(row: 0, section: accountSection))?.accessoryType, .checkmark)
        XCTAssertEqual(viewModel.row(at: IndexPath(row: 1, section: accountSection))?.accessoryType, Table.Row.AccessoryType.none)
    }
    
    func testRowAtIndexPath_whenUsernameMatchesTheSelectedOneStoredInUserDefaults_shouldUseCheckmarkAsAccessoryType() {
        /// Given
        let username = "lorem.ipsum"
        userDefaults.set(username, forKey: selectedUsernameUserDefaultsKey)
        
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: username, credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries and the `UserDefaults` values are retrieved during initialization.
        recreateViewModel()
        
        XCTAssertEqual(viewModel.row(at: IndexPath(row: 0, section: accountSection))?.accessoryType, Table.Row.AccessoryType.none)
        XCTAssertEqual(viewModel.row(at: IndexPath(row: 1, section: accountSection))?.accessoryType, .checkmark)
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
    
    func testSelectRow_whenTappingAnActualAccountRow_shouldSaveCorrespondingUsernameToUserDefaults() {
        /// Given
        let usernameOfSecondAccount = "lorem.ipsum"
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: usernameOfSecondAccount, credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "foo.bar", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        viewModel.selectRow(at: IndexPath(row: 1, section: UploadViewModel.SectionIndex.accounts.rawValue))
        
        XCTAssertEqual(userDefaults.string(forKey: selectedUsernameUserDefaultsKey), usernameOfSecondAccount)
    }
    
    func testSelectRow_whenTappingAnActualAccountRow_shouldAskDelegateToReloadAccountSection() {
        /// Given
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "lorem.ipsum", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        /// When
        viewModel.selectRow(at: IndexPath(row: 1, section: accountSection))
        
        /// Then
        XCTAssertTrue(delegateMock.didCallReloadReloadSection)
        XCTAssertEqual(delegateMock.sectionToReload, accountSection)
    }
    
    func testSelectRow_whenTappingAnAccountRowThatIsAlreadySelected_shouldNotAskDelegateToReloadAccountSection() {
        /// Given
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        let selectedUsername = "lorem.ipsum"
        userDefaults.set(selectedUsername, forKey: selectedUsernameUserDefaultsKey)
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: selectedUsername, credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        /// When
        viewModel.selectRow(at: IndexPath(row: 1, section: accountSection))
        
        /// Then
        XCTAssertFalse(delegateMock.didCallReloadReloadSection)
    }
    
    func testSelectRow_whenTappingAnActualAccountRow_shouldUseCheckmarkAsAccessoryTypeForThatRow() {
        /// Given
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "lorem.ipsum", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: "foo.bar", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        let indexPathOfRowToSelect = IndexPath(row: 2, section: accountSection)
        
        /// Re-generate the view model, since the keychain handler's entries are retrieved during initialization.
        recreateViewModel()
        
        /// When
        viewModel.selectRow(at: indexPathOfRowToSelect)
        
        /// Then
        XCTAssertEqual(viewModel.row(at: indexPathOfRowToSelect)?.accessoryType, .checkmark)
    }
    
    func testSelectRow_whenTappingLastRowInAccountSection_shouldAskCoordinatorToStartAddAccountFlow() {
        /// Given
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        let indexOfLastRow = viewModel.numberOfRows(in: accountSection) - 1
        
        /// When
        viewModel.selectRow(at: IndexPath(row: indexOfLastRow, section: accountSection))
        
        /// Then
        XCTAssertTrue(coordinatorMock.didCallStartAddAccountFlow)
    }
    
    func test_whenReceivingKeychainDidChangeNumberOfEntriesNotification_shouldUpdateAccountSectionRows() {
        /// Given
        let accountSection = UploadViewModel.SectionIndex.accounts.rawValue
        
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
    
    // MARK: didTapUploadButton()
    
    func testDidTapUploadButton_whenNoAccountsAreAvailable_shouldNotAskCoordinatorToStartUpload() {
        /// Given
        keychainHandlerMock.entries = []
        
        /// Re-generate the view model, since the keychain handler's entries and the `UserDefaults` are retrieved during initialization.
        recreateViewModel()
        
        /// When
        viewModel.didTapUploadButton()
        
        /// Then
        XCTAssertFalse(coordinatorMock.didCallStartUpload)
    }
    
    func testDidTapUploadButton_whenNoUsernameMatchesTheSelectedOneStoredInUserDefaults_shouldAskCoordinatorToStartUploadWithTheFirstAccount() {
        /// Given
        userDefaults.set("something random", forKey: selectedUsernameUserDefaultsKey)
        
        let credentialsOfFirstAccount = OAuth1Credentials(token: "foo", tokenSecret: "bar")
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: credentialsOfFirstAccount),
                                       (username: "lorem.ipsum", credentials: OAuth1Credentials(token: "", tokenSecret: ""))]
        
        /// Re-generate the view model, since the keychain handler's entries and the `UserDefaults` are retrieved during initialization.
        recreateViewModel()
        
        /// When
        viewModel.didTapUploadButton()
        
        /// Then
        XCTAssertTrue(coordinatorMock.didCallStartUpload)
        XCTAssertEqual(coordinatorMock.oAuthCredentialsForUpload, credentialsOfFirstAccount)
    }
    
    func testDidTapUploadButton_whenUsernameMatchesTheSelectedOneStoredInUserDefaults_shouldAskCoordinatorToStartUploadWithThatAccount() {
        /// Given
        let username = "lorem.ipsum"
        let credentials = OAuth1Credentials(token: "foo", tokenSecret: "bar")
        userDefaults.set(username, forKey: selectedUsernameUserDefaultsKey)
        
        keychainHandlerMock.entries = [(username: "jane.doe", credentials: OAuth1Credentials(token: "", tokenSecret: "")),
                                       (username: username, credentials: credentials)]
        
        /// Re-generate the view model, since the keychain handler's entries and the `UserDefaults` are retrieved during initialization.
        recreateViewModel()
        
        /// When
        viewModel.didTapUploadButton()
        
        /// Then
        XCTAssertTrue(coordinatorMock.didCallStartUpload)
        XCTAssertEqual(coordinatorMock.oAuthCredentialsForUpload, credentials)
    }
    
    // MARK: Helper methods
    
    private func recreateViewModel(questId: Int = 0) {
        viewModel = UploadViewModel(keychainHandler: keychainHandlerMock,
                                    notificationCenter: notificationCenter,
                                    userDefaults: userDefaults,
                                    selectedUsernameUserDefaultsKey: selectedUsernameUserDefaultsKey,
                                    questId: questId)
        
        viewModel.coordinator = coordinatorMock
        viewModel.delegate = delegateMock
    }

}
