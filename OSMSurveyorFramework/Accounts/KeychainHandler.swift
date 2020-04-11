//
//  KeychainHandler.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import KeychainAccess

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
    var entries: [(username: String, credentials: OAuth1Credentials)] { get }
    
    /// Adds a new account to the keychain.
    /// - Parameters:
    ///   - username: The username of the account.
    ///   - credentials: The OAuth1 credentials.
    func add(username: String, credentials: OAuth1Credentials)
    
    func remove(username: String)
}

public class KeychainHandler {
    private let keychain: Keychain
    
    public init(service: String) {
        keychain = Keychain(service: service)
    }
}

extension KeychainHandler: KeychainHandling {
    public var entries: [(username: String, credentials: OAuth1Credentials)] {
        let decoder = JSONDecoder()
        
        return keychain.allKeys().compactMap { username in
            guard
                let credentialsAsData = keychain[data: username],
                let credentials = try? decoder.decode(OAuth1Credentials.self, from: credentialsAsData)
            else {
                return nil
            }
            
            return (username, credentials)
        }
    }
    
    public func add(username: String, credentials: OAuth1Credentials) {
        let encoder = JSONEncoder()
        guard let credentialsAsData = try? encoder.encode(credentials) else { return }
        
        keychain[data: username] = credentialsAsData
    }
    
    public func remove(username: String) {
        keychain[username] = nil
    }
}
