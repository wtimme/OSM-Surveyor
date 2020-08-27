//
//  QuestElementProcessorMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class QuestElementProcessorMock {
    private(set) var didCallProcessElements = false
    private(set) var processElementsArguments: (elements: [(Element, ElementGeometry?)], boundingBox: BoundingBox, questType: String)?
}

extension QuestElementProcessorMock: QuestElementProcessing {
    func processElements(_ elements: [(Element, ElementGeometry?)], in boundingBox: BoundingBox, forQuestOfType questType: String) {
        didCallProcessElements = true

        processElementsArguments = (elements, boundingBox, questType)
    }
}
