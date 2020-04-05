//
//  OverpassQuest.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol OverpassQuest {
    /// A string that references the quest (e. g. in the database)
    var type: String { get }
    
    /// Determines the query for downloading the quest's elements in the given `BoundingBox`
    /// - Parameter boundingBox: The bounding box for which to get the query.
    func query(boundingBox: BoundingBox) -> String
}
