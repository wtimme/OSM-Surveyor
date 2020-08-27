//
//  KeychainHandlerTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 12.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
import XCTest

class KeychainHandlerTestCase: XCTestCase {
    var handler: KeychainHandling!
    var notificationCenter: NotificationCenter!

    override func setUpWithError() throws {
        notificationCenter = NotificationCenter()

        /// For the service name, use something that is unique, in order to avoid needing to remove all items when tearing down.
        let uniqueServiceName = "test_\(Date().timeIntervalSince1970)"

        handler = KeychainHandler(service: uniqueServiceName,
                                  notificationCenter: notificationCenter)
    }

    override func tearDownWithError() throws {
        handler = nil
        notificationCenter = nil
    }

    func testAdd_shouldInsertEntry() {
        let username = "jane.doe"
        let credentials = OAuth1Credentials(token: "lorem",
                                            tokenSecret: "ipsum")

        try? handler.add(username: username, credentials: credentials)

        XCTAssertEqual(handler.entries.first?.username, username)
        XCTAssertEqual(handler.entries.first?.credentials, credentials)
    }

    func testAdd_whenAddingAnEntry_shouldPostNotification() {
        let username = "jane.doe"
        let credentials = OAuth1Credentials(token: "lorem",
                                            tokenSecret: "ipsum")

        _ = expectation(forNotification: .keychainHandlerDidChangeNumberOfEntries,
                        object: nil,
                        notificationCenter: notificationCenter)

        try? handler.add(username: username, credentials: credentials)

        waitForExpectations(timeout: 10)
    }

    func testAdd_whenAddingAnEntryThatAlreadyExists_shouldNotPostNotification() {
        let username = "jane.doe"
        let credentials = OAuth1Credentials(token: "lorem",
                                            tokenSecret: "ipsum")

        /// Add the entry for the first time.
        try? handler.add(username: username, credentials: credentials)

        let notificationExpectation = expectation(forNotification: .keychainHandlerDidChangeNumberOfEntries,
                                                  object: nil,
                                                  notificationCenter: notificationCenter)
        notificationExpectation.isInverted = true

        /// Add the same entry another time.
        try? handler.add(username: username, credentials: credentials)

        waitForExpectations(timeout: 1)
    }

    func testAdd_whenInsertingAUsernameThatAlreadyExists_shouldThrowCorrespondingError() {
        let username = "jane.doe"
        let credentials = OAuth1Credentials(token: "lorem", tokenSecret: "ipsum")

        /// Add the entry for the first time.
        try? handler.add(username: username, credentials: credentials)

        do {
            /// Add the entry for a second time.
            try handler.add(username: username, credentials: credentials)

            /// Adding an entry for a username that already exist should throw; execution should jump to `catch` clause and _not_ continue here.
            XCTFail()
        } catch {
            XCTAssertEqual(error as? KeychainError, KeychainError.usernameAlreadyExists)
        }
    }

    func testAdd_whenInsertingTheSameUsernameMultipleTimes_shouldResultInOnlyOneEntry() {
        for _ in 1 ... 10 {
            let username = "jane.doe"
            let credentials = OAuth1Credentials(token: "lorem",
                                                tokenSecret: "ipsum")

            try? handler.add(username: username, credentials: credentials)
        }

        XCTAssertEqual(handler.entries.count, 1)
    }

    func testRemove_shouldRemoveTheItem() {
        let username = "jane.doe"
        let credentials = OAuth1Credentials(token: "lorem",
                                            tokenSecret: "ipsum")

        try? handler.add(username: username, credentials: credentials)

        handler.remove(username: username)

        let usernamesInKeychain = handler.entries.map { $0.username }
        XCTAssertFalse(usernamesInKeychain.contains(username))
    }

    func testRemove_whenRemovingAnEntry_shouldPostNotification() {
        let username = "jane.doe"
        let credentials = OAuth1Credentials(token: "lorem",
                                            tokenSecret: "ipsum")

        try? handler.add(username: username, credentials: credentials)

        _ = expectation(forNotification: .keychainHandlerDidChangeNumberOfEntries,
                        object: nil,
                        notificationCenter: notificationCenter)

        handler.remove(username: username)

        waitForExpectations(timeout: 1)
    }

    func testRemove_whenRemovingAnEntryThatDoesNotExist_shouldNotPostNotification() {
        let notificationExpectation = expectation(forNotification: .keychainHandlerDidChangeNumberOfEntries,
                                                  object: nil,
                                                  notificationCenter: notificationCenter)
        notificationExpectation.isInverted = true

        handler.remove(username: "")

        waitForExpectations(timeout: 1)
    }
}
