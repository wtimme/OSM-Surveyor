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

    private let zoomForDownloadedTiles: Int
    private let downloadedQuestTypesManager: DownloadedQuestTypesManaging
    private let questDataManager: QuestDataManaging
    private let elementGeometryDataManager: ElementGeometryDataManaging
    private let nodeDataManager: NodeDataManaging

    // MARK: Initializer

    init(zoomForDownloadedTiles: Int,
         downloadedQuestTypesManager: DownloadedQuestTypesManaging,
         questDataManager: QuestDataManaging,
         elementGeometryDataManager: ElementGeometryDataManaging,
         nodeDataManager: NodeDataManaging)
    {
        self.zoomForDownloadedTiles = zoomForDownloadedTiles
        self.downloadedQuestTypesManager = downloadedQuestTypesManager
        self.questDataManager = questDataManager
        self.elementGeometryDataManager = elementGeometryDataManager
        self.nodeDataManager = nodeDataManager
    }
}

extension QuestElementProcessor: QuestElementProcessing {
    func processElements(_ elements: [(Element, ElementGeometry?)], in boundingBox: BoundingBox, forQuestOfType questType: String) {
        for elementToProcess in elements {
            guard let geometry = elementToProcess.1 else {
                print("\(questType): Not adding a quest because the element \(elementToProcess.0.type.rawValue)#\(elementToProcess.0.id) has no valid geometry")
                continue
            }

            guard let node = elementToProcess.0 as? Node else {
                assertionFailure("As of now, only nodes are supported.")
                continue
            }

            questDataManager.insert(questType: questType, elementId: Int(elementToProcess.0.id), geometry: geometry)
            elementGeometryDataManager.insert(geometry)
            nodeDataManager.insert(node)
        }

        downloadedQuestTypesManager.markQuestTypeAsDownloaded(tilesRect: boundingBox.enclosingTilesRect(zoom: zoomForDownloadedTiles),
                                                              questType: questType)
    }
}
