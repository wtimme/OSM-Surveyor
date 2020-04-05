//
//  QuestManaging.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol QuestManaging {
    /// Updates the `Quest`s in the given `BoundingBox`
    /// - Parameter boundingBox: The `BoundingBox` in which to update the quests.
    /// - Parameter ignoreDownloadedQuestsBefore: Already downloaded quests that are older than this `Date` are not considered "downloaded" anymore, and will be fetched again.
    func updateQuests(in boundingBox: BoundingBox,
                      ignoreDownloadedQuestsBefore date: Date)
}
