//
//  AccountHandlerMock.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class AccountHandlerMock {
    var accounts = [Account]()
}

extension AccountHandlerMock: AccountHandling {}
