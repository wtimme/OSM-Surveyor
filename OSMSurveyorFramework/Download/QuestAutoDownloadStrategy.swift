//
//  QuestAutoDownloadStrategy.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 01.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// An object that controls how quests are being downloaded automatically.
///
/// Source: https://github.com/westnordost/StreetComplete/blob/master/app/src/main/java/de/westnordost/streetcomplete/data/download/QuestAutoDownloadStrategy.kt
protocol QuestAutoDownloadStrategy {
    /// The number of quest types to retrieve in one run
    var questTypeDownloadCount: Int { get }
    
    /// Determines if quests should be downloaded automatically at the given position now.
    /// - Parameter position: The position at which quests might be downloaded.
    func mayDownloadHere(position: Coordinate) -> Bool
    
    /// Determines the `BoundingBox` that should be downloaded at the given position position (if `mayDownloadHere(position:)` returned `true`)
    /// - Parameter position: The position at which quests might be downloaded.
    func downloadBoundingBox(position: Coordinate) -> BoundingBox
}
