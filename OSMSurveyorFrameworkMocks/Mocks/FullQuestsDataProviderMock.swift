//
//  FullQuestsDataProviderMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class FullQuestsDataProviderMock {
    private(set) var didCallFindElementKeysForQuests = false
    private(set) var findElementKeysForQuestsArguments: (questTypes: [String], boundingBox: BoundingBox)?
    var elementKeysToReturn = [ElementKey]()

    private(set) var didCallFindQuests = false
    private(set) var findQuestsCallCounter = 0
    private(set) var findQuestsBoundingBox: BoundingBox?
    var questsToReturn = [(elementType: String, elementId: Int, coordinate: Coordinate, questType: String)]()
}

extension FullQuestsDataProviderMock: FullQuestsDataProviding {
    func findElementKeysForQuests(ofTypes questTypes: [String], in boundingBox: BoundingBox) -> [ElementKey] {
        didCallFindElementKeysForQuests = true

        findElementKeysForQuestsArguments = (questTypes, boundingBox)

        return elementKeysToReturn
    }

    func findQuests(in boundingBox: BoundingBox) -> [(elementType: String, elementId: Int, coordinate: Coordinate, questType: String)] {
        didCallFindQuests = true
        findQuestsCallCounter += 1

        findQuestsBoundingBox = boundingBox

        return questsToReturn
    }
}
