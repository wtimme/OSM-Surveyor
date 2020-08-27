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

extension Notification.Name {
    /// Is posted when the Keychain handler has either added or removed an entry.
    public static let keychainHandlerDidChangeNumberOfEntries = Notification.Name("keychainHandlerDidChangeNumberOfEntries")
}

public enum KeychainError: Error {
    /// The Keychain already contains an entry for the given username.
    case usernameAlreadyExists
}

public protocol KeychainHandling {
    var entries: [(username: String, credentials: OAuth1Credentials)] { get }

    /// Adds a new account to the keychain.
    /// - Parameters:
    ///   - username: The username of the account.
    ///   - credentials: The OAuth1 credentials.
    func add(username: String, credentials: OAuth1Credentials) throws

    func remove(username: String)
}

public class KeychainHandler {
    private let keychain: Keychain
    private let notificationCenter: NotificationCenter

    public init(service: String, notificationCenter: NotificationCenter = .default) {
        keychain = Keychain(service: service)
        self.notificationCenter = notificationCenter
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

    public func add(username: String, credentials: OAuth1Credentials) throws {
        guard !keychain.allKeys().contains(username) else {
            throw KeychainError.usernameAlreadyExists
        }

        let encoder = JSONEncoder()
        guard let credentialsAsData = try? encoder.encode(credentials) else { return }

        keychain[data: username] = credentialsAsData

        notificationCenter.post(name: .keychainHandlerDidChangeNumberOfEntries, object: nil)
    }

    public func remove(username: String) {
        guard keychain.allKeys().contains(username) else {
            /// The Keychain does not have an account with the given `username`.
            return
        }

        keychain[username] = nil

        notificationCenter.post(name: .keychainHandlerDidChangeNumberOfEntries, object: nil)
    }
}
