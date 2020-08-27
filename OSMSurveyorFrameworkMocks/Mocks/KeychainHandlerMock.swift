//
//  KeychainHandlerMock.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 12.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class KeychainHandlerMock {
    var entries = [(username: String, credentials: OAuth1Credentials)]()

    private(set) var didCallAdd = false
    private(set) var addArguments: (username: String, credentials: OAuth1Credentials)?
    var addError: Error?

    private(set) var didCallRemove = false
    private(set) var usernameToRemove: String?
}

extension KeychainHandlerMock: KeychainHandling {
    func add(username: String, credentials: OAuth1Credentials) throws {
        didCallAdd = true

        addArguments = (username, credentials)

        if let error = addError {
            throw error
        }
    }

    func remove(username: String) {
        didCallRemove = true

        usernameToRemove = username
    }
}
