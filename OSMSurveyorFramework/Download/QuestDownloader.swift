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
}

extension QuestDownloader: QuestDownloading {
    func download(tilesRect: TilesRect, maxQuestTypesToDownload: Int?, isPriority: Bool) {
        /// TODO: Implement me.
    }
}
