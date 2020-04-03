//
//  QuestController.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 03.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol QuestControlling {
    /// Download quests in at least the given bounding box asynchronously. The next-bigger rectangle
    /// in a (z14) tiles grid that encloses the given bounding box will be downloaded.
    ///
    /// - Parameters:
    ///     - boundingBox: The minimum area to download
    ///     - maxQuestTypesToDownload: Download at most the given number of quest types. `nil` for unlimited
    ///     - isPriority: Whether this shall be a priority download (cancels previous downloads and puts itself in the front)
    func download(boundingBox: BoundingBox, maxQuestTypesToDownload: Int?, isPriority: Bool)
}

final class QuestController {
    // MARK: Private properties
    
    private let questTileZoom: Int
    private let downloader: QuestDownloading
    
    // MARK: Initializer
    
    init(questTileZoom: Int = 14, downloader: QuestDownloading) {
        self.questTileZoom = questTileZoom
        self.downloader = downloader
    }
}

extension QuestController: QuestControlling {
    func download(boundingBox: BoundingBox, maxQuestTypesToDownload: Int?, isPriority: Bool) {
        let tilesRect = boundingBox.enclosingTilesRect(zoom: questTileZoom)
        
        downloader.download(tilesRect: tilesRect, maxQuestTypesToDownload: maxQuestTypesToDownload, isPriority: isPriority)
    }
}
