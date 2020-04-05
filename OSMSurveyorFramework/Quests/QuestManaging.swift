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
    func updateQuests(in boundingBox: BoundingBox)
}
