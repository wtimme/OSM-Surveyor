//
//  KeychainHandler.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// The token and its secret for OAuth1
public struct OAuth1Credentials: Codable, Equatable {
    public let token: String
    public let tokenSecret: String
    
    public init(token: String, tokenSecret: String) {
        self.token = token
        self.tokenSecret = tokenSecret
    }
}

public protocol KeychainHandling {
}

public class KeychainHandler {
}

extension KeychainHandler: KeychainHandling {
}
