//
//  SettingsCoordinatorMock.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyor

final class SettingsCoordinatorMock {
    private(set) var didCallStartAddAccountFlow = false
    private(set) var didCallPresentGitHubRepository = false
    private(set) var didCallPresentBugTracker = false
    private(set) var didCallPresentPrivacyStatement = false

    private(set) var didCallAskForConfirmationToRemoveAccount = false
    private(set) var askForConfirmationToRemoveAccountArguments: (username: String, confirm: () -> Void)?
}

extension SettingsCoordinatorMock: SettingsCoordinatorProtocol {
    func start() {}

    func startAddAccountFlow() {
        didCallStartAddAccountFlow = true
    }

    func askForConfirmationToRemoveAccount(username: String, _ confirm: @escaping () -> Void) {
        didCallAskForConfirmationToRemoveAccount = true

        askForConfirmationToRemoveAccountArguments = (username, confirm)
    }

    func presentGitHubRepository() {
        didCallPresentGitHubRepository = true
    }

    func presentBugTracker() {
        didCallPresentBugTracker = true
    }

    func presentPrivacyStatement() {
        didCallPresentPrivacyStatement = true
    }
}
