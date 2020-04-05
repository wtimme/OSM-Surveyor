//
//  OverpassQuestManager.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

final class OverpassQuestManager {
    // MARK: Private properties
    private let questProvider: OverpassQuestProviding
    private let queryExecutor: OverpassQueryExecuting
    private let zoomForDownloadedTiles: Int
    private let downloadedQuestTypesManager: DownloadedQuestTypesManaging
    
    init(questProvider: OverpassQuestProviding,
         queryExecutor: OverpassQueryExecuting,
         zoomForDownloadedTiles: Int,
         downloadedQuestTypesManager: DownloadedQuestTypesManaging) {
        self.questProvider = questProvider
        self.queryExecutor = queryExecutor
        self.zoomForDownloadedTiles = zoomForDownloadedTiles
        self.downloadedQuestTypesManager = downloadedQuestTypesManager
    }
}

extension OverpassQuestManager: QuestManaging {
    func updateQuests(in boundingBox: BoundingBox, ignoreDownloadedQuestsBefore date: Date) {
        let tilesRect = boundingBox.enclosingTilesRect(zoom: zoomForDownloadedTiles)
        
        let downloadedQuestTypes = downloadedQuestTypesManager.findDownloadedQuestTypes(in: tilesRect, ignoreOlderThan: date)
        
        let questsToDownload = questProvider.quests.filter { quest in
            return !downloadedQuestTypes.contains(quest.type)
        }
        
        for quest in questsToDownload {
            let query = quest.query(boundingBox: boundingBox)
            
            queryExecutor.execute(query: query) { result in
                /// TODO: Implement me.
            }
        }
    }
}
