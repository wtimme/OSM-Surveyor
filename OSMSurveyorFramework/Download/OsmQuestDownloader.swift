//
//  OsmQuestDownloader.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 04.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol OsmQuestDownloading {
    func download(questType: QuestTypeProtocol,
                  boundingBox: BoundingBox,
                  blacklistedPositions: Set<Coordinate>,
                  completion: (Bool) -> Void)
}

class OsmQuestDownloader {
}

extension OsmQuestDownloader: OsmQuestDownloading {
    func download(questType: QuestTypeProtocol, boundingBox: BoundingBox, blacklistedPositions: Set<Coordinate>, completion: (Bool) -> Void) {
        /// TODO: Implement me.
    }
}
