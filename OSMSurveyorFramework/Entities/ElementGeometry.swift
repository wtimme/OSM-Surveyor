//
//  ElementGeometry.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 04.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// Information on the geometry of a quest
struct ElementGeometry {
    typealias Polyline = [Coordinate]
    typealias Polygon = [Coordinate]

    enum ElementType: String {
        case node = "NODE"
        case way = "WAY"
        case relation = "RELATION"
    }

    let type: ElementType
    let elementId: Int
    let polylines: [Polyline]?
    let polygons: [Polygon]?
    let center: Coordinate
}

extension ElementGeometry: Equatable {}
