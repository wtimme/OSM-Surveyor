//
//  Coordinate.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct Coordinate {
    public let latitude: Double
    public let longitude: Double
}

extension Coordinate: Equatable {}

extension Coordinate {
    static let minimumValue = Coordinate(latitude: -90, longitude: -180)
    static let maximumValue = Coordinate(latitude: 90, longitude: 180)
}
