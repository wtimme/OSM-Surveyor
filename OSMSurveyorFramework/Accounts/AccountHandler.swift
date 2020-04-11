//
//  AccountHandler.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct Account {
    let uuid: UUID
    let username: String
}

public protocol AccountHandling {
    var accounts: [Account] { get }
}

public final class AccountHandler {
    public private(set) var accounts = [Account]()
}

extension AccountHandler: AccountHandling {
}
