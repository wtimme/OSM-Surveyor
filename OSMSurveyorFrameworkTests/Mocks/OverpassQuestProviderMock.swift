//
//  OverpassQuestProviderMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class OverpassQuestProviderMock {
    var quests = [OverpassQuest]()
}

extension OverpassQuestProviderMock: OverpassQuestProviding {}
