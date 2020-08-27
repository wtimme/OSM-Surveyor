//
//  QuestDataManagerMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class QuestDataManagerMock {
    private(set) var didCallInsert = false
    private(set) var insertArguments: (questType: String, elementId: Int, geometry: ElementGeometry)?
}

extension QuestDataManagerMock: QuestDataManaging {
    func insert(questType: String, elementId: Int, geometry: ElementGeometry) {
        didCallInsert = true

        insertArguments = (questType, elementId, geometry)
    }
}
