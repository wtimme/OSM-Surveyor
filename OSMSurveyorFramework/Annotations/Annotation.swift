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
    
    public init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
}

extension Annotation: Equatable {}
