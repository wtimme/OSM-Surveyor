//
//  Annotation.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct Annotation {
    /// The OpenStreetMap ID of the annotated element.
    public let elementId: Int

    /// The center coordinate of the object.
    public let coordinate: Coordinate

    public init(elementId: Int,
                coordinate: Coordinate)
    {
        self.elementId = elementId
        self.coordinate = coordinate
    }
}

extension Annotation: Equatable {}
