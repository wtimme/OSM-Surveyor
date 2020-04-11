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
    private(set) var didCallPresentGitHubRepository = false
}

extension SettingsCoordinatorMock: SettingsCoordinatorProtocol {
    func start() {}
    
    func presentGitHubRepository() {
        didCallPresentGitHubRepository = true
    }
}
