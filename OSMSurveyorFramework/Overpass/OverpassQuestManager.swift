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
    private let downloadedQuestTypesManager: DownloadedQuestTypesManaging
    
    init(downloadedQuestTypesManager: DownloadedQuestTypesManaging) {
        self.downloadedQuestTypesManager = downloadedQuestTypesManager
    }
}

extension OverpassQuestManager: QuestManaging {
    func updateQuests(in boundingBox: BoundingBox) {
        _ = downloadedQuestTypesManager.findDownloadedQuestTypes(in: TilesRect(left: 0, top: 1, right: 2, bottom: 3), ignoreOlderThan: Date())
    }
}
