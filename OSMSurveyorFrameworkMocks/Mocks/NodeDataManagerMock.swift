//
//  NodeDataManagerMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class NodeDataManagerMock {
    private(set) var didCallInsert = false
    private(set) var insertElement: Node?
}

extension NodeDataManagerMock: NodeDataManaging {
    func insert(_ node: Node) {
        didCallInsert = true

        insertElement = node
    }
}
