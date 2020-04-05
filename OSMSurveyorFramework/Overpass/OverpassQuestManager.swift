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
