//
//  OverpassQueryExecutorMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class OverpassQueryExecutorMock {
    private(set) var didCallExecuteQuery = false
    private(set) var executeQueryArguments: (query: OverpassQuery, completion: (OverpassQueryResult) -> Void)?
}

extension OverpassQueryExecutorMock: OverpassQueryExecuting {
    func execute(query: OverpassQuery, completion: @escaping (OverpassQueryResult) -> Void) {
        didCallExecuteQuery = true

        executeQueryArguments = (query, completion)
    }
}
