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
}

extension SettingsCoordinatorMock: SettingsCoordinatorProtocol {
    func start() {}
    
    func startAddAccountFlow() {
        didCallStartAddAccountFlow = true
    }
    
    func presentGitHubRepository() {
        didCallPresentGitHubRepository = true
    }
    
    func presentBugTracker() {
        didCallPresentBugTracker = true
    }
}
