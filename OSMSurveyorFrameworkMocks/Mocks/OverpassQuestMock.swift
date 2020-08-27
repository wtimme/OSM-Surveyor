//
//  OverpassQuestMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class OverpassQuestMock {
    let type: String

    init(type: String) {
        self.type = type
    }

    private(set) var didCallQuery = false
    private(set) var queryBoundingBox: BoundingBox?
    var queryToReturn: OverpassQuery = ""
}

extension OverpassQuestMock: OverpassQuest {
    func query(boundingBox: BoundingBox) -> OverpassQuery {
        didCallQuery = true

        queryBoundingBox = boundingBox

        return queryToReturn
    }
}
