//
//  AlertPresenterMock.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyor

final class AlertPresenterMock {
    private(set) var didCallPresentAlert = false
    private(set) var presentAlertArguments: (title: String, message: String)?
}

extension AlertPresenterMock: AlertPresenting {
    func presentAlert(title: String, message: String) {
        didCallPresentAlert = true

        presentAlertArguments = (title, message)
    }
}
