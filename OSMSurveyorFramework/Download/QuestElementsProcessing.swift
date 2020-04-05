//
//  QuestElementsProcessing.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// An object that processes downloaded elements for a quest.
/// The logic implemented is similar to StreetComplete's `OsmQuestDownloader`.
protocol QuestElementProcessing {
    /// Processes the given elements.
    /// - Parameters:
    ///   - elements: The elements to process.
    ///   - boundingBox: The bounding box that was downloaded.
    ///   - questType: The type of quest that the elements belong to.
    func processElements(_ elements: [(Element, ElementGeometry?)],
                         in boundingBox: BoundingBox,
                         forQuestOfType questType: String)
}
