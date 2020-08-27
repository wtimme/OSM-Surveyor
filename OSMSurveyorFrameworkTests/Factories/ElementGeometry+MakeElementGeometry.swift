//
//  ElementGeometry+MakeElementGeometry.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

extension ElementGeometry {
    static func makeGeometry(type: ElementType = .node,
                             elementId: Int = 4,
                             polylines: [Polyline]? = nil,
                             polygons: [Polygon]? = nil,
                             center: Coordinate = Coordinate(latitude: 49.1, longitude: 8.1)) -> ElementGeometry
    {
        return ElementGeometry(type: type,
                               elementId: elementId,
                               polylines: polylines,
                               polygons: polygons,
                               center: center)
    }
}
