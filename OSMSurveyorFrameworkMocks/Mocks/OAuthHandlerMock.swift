//
//  OAuthHandlerMock.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class OAuthHandlerMock {
    private(set) var didCallAuthorize = false
    private(set) var authorizeFromViewController: Any?
    private(set) var authorizeCompletion: ((OAuthAuthorizationResult) -> Void)?

    private(set) var didCallHandleURL = false
    private(set) var urlToHandle: URL?
}

extension OAuthHandlerMock: OAuthHandling {
    func authorize(from viewController: Any, completion: @escaping (OAuthAuthorizationResult) -> Void) {
        didCallAuthorize = true

        authorizeFromViewController = viewController
        authorizeCompletion = completion
    }

    func handle(url: URL) {
        didCallHandleURL = true

        urlToHandle = url
    }
}
