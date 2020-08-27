//
//  Account+MakeAccount.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework

extension Account {
    static func makeAccount(uuid: UUID = UUID(),
                            username: String = "jane.doe") -> Account
    {
        return Account(uuid: uuid,
                       username: username)
    }
}
