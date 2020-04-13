//
//  Annotation.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct Annotation {
    public let coordinate: Coordinate
    public let questType: String
    public let questId: Int
    
    public init(coordinate: Coordinate,
                questType: String,
                questId: Int) {
        self.coordinate = coordinate
        self.questType = questType
        self.questId = questId
    }
}

extension Annotation: Equatable {}
