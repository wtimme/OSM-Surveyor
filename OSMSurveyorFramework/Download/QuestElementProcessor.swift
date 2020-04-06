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
    private let elementGeometryDataManager: ElementGeometryDataManaging
    
    // MARK: Initializer
    init(questDataManager: QuestDataManaging, elementGeometryDataManager: ElementGeometryDataManaging) {
        self.questDataManager = questDataManager
        self.elementGeometryDataManager = elementGeometryDataManager
    }
}

extension QuestElementProcessor: QuestElementProcessing {
    func processElements(_ elements: [(Element, ElementGeometry?)], in boundingBox: BoundingBox, forQuestOfType questType: String) {
        for elementToProcess in elements {
            guard let geometry = elementToProcess.1 else {
                print("\(questType): Not adding a quest because the element \(elementToProcess.0.type.rawValue)#\(elementToProcess.0.id) has no valid geometry")
                continue
            }
            
            questDataManager.insert(questType: questType, elementId: Int(elementToProcess.0.id), geometry: geometry)
            elementGeometryDataManager.insert(geometry)
        }
    }
}
