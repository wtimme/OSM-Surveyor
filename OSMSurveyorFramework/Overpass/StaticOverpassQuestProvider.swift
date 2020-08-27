//
//  StaticOverpassQuestProvider.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct StaticOverpassQuestProvider {
    let quests: [OverpassQuest]

    init(quests: [OverpassQuest] = [AddBenchBackrestQuest(),
                                    AddBusStopShelterQuest()])
    {
        self.quests = quests
    }
}

extension StaticOverpassQuestProvider: OverpassQuestProviding {}
