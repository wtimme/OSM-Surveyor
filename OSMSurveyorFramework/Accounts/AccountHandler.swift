//
//  AccountHandler.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct Account {
    public let uuid: UUID
    public let username: String
}

public protocol AccountHandling {
    var accounts: [Account] { get }
}

public final class AccountHandler {
    // MARK: Public properties

    public private(set) var accounts = [Account]()

    /// Singleton instance of the handler.
    public static let shared: AccountHandling = AccountHandler()
}

extension AccountHandler: AccountHandling {}
