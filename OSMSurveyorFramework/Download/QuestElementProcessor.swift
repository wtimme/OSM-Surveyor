//
//  QuestElementProcessor.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

final class QuestElementProcessor {
    // MARK: Private properties
    private let questDataManager: QuestDataManaging
    
    // MARK: Initializer
    init(questDataManager: QuestDataManaging) {
        self.questDataManager = questDataManager
    }
}

extension QuestElementProcessor: QuestElementProcessing {
    func processElements(_ elements: [(Element, ElementGeometry?)], in boundingBox: BoundingBox, forQuestOfType questType: String) {
        /// TODO: Implement me.
    }
}
