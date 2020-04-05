//
//  QuestDownloader.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 03.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol QuestDownloading {
    /// Download quests in the given `TilesRect`.
    ///
    /// - Parameters:
    ///     - tilesRect: The tiles rect in which to download the quests.
    ///     - maxQuestTypesToDownload: Download at most the given number of quest types. `nil` for unlimited
    ///     - isPriority: Whether this shall be a priority download (cancels previous downloads and puts itself in the front)
    func download(tilesRect: TilesRect, maxQuestTypesToDownload: Int?, isPriority: Bool)
}

class QuestDownloader {
    // MARK: Private properties
    
    private let questProvider: QuestProviding
    private let downloadedQuestTypesManager: DownloadedQuestTypesManaging
    private let overpassDownloader: OverpassDownloading
    
    /// A "best before" duration for quests. Quests will not be downloaded again for any tile before the time expired
    private let questExpirationTime: TimeInterval
    
    // MARK: Initializer
    
    init(questProvider: QuestProviding,
         downloadedQuestTypesManager: DownloadedQuestTypesManaging,
         overpassDownloader: OverpassDownloading,
         questExpirationTime: TimeInterval = 7 * 24 * 60 * 60) {
        self.questProvider = questProvider
        self.downloadedQuestTypesManager = downloadedQuestTypesManager
        self.overpassDownloader = overpassDownloader
        self.questExpirationTime = questExpirationTime
    }
    
    private func questsToDownload(tilesRect: TilesRect, maxQuestTypes: Int?) -> [QuestTypeProtocol] {
        let questExpirationDate = Date(timeIntervalSinceNow: -questExpirationTime)
        
        let alreadyDownloadedQuestTypes = downloadedQuestTypesManager.findDownloadedQuestTypes(in: tilesRect,
                                                                                               ignoreOlderThan: questExpirationDate)
        
        let questsNotDownloadedYet = questProvider.quests.filter { quest in
            !alreadyDownloadedQuestTypes.contains(quest.type)
        }
        
        let numberOfQuestsToDownload: Int
        if let maxQuestTypes = maxQuestTypes, maxQuestTypes > 0 {
            numberOfQuestsToDownload = min(questsNotDownloadedYet.count, maxQuestTypes)
        } else {
            numberOfQuestsToDownload = questsNotDownloadedYet.count
        }
        
        return Array(questsNotDownloadedYet[0..<numberOfQuestsToDownload])
    }
    
    private func downloadQuest(_ quest: QuestTypeProtocol, tilesRect: TilesRect) {
        quest.download(boundingBox: tilesRect.asBoundingBox(), using: overpassDownloader) { [weak self] result in
            switch result {
            case let .failure(error):
                assertionFailure("Failed to download quest: \(error.localizedDescription)")
            case let .success(elements):
                self?.processDownloadedQuest(quest, elements: elements)
                
                try? self?.downloadedQuestTypesManager.markQuestTypeAsDownloaded(tilesRect: tilesRect, questType: quest.type)
            }
        }
    }
    
    private func processDownloadedQuest(_ quest: QuestTypeProtocol, elements: [(Element, ElementGeometry?)]) {
        /// TODO: Implement me.
    }
}

extension QuestDownloader: QuestDownloading {
    func download(tilesRect: TilesRect, maxQuestTypesToDownload: Int?, isPriority: Bool) {
        let quests = questsToDownload(tilesRect: tilesRect, maxQuestTypes: maxQuestTypesToDownload ?? 0)
        
        guard !quests.isEmpty else {
            print("Won't download any quests.")
            return
        }
        
        print("Will download \(quests.map(\.type).joined(separator: ", "))")
        
        quests.forEach { quest in
            downloadQuest(quest, tilesRect: tilesRect)
        }
    }
}
