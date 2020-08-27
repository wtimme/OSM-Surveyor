//
//  BoundingBox+MakeBoundingBox.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

extension BoundingBox {
    static func makeBoundingBox(minimum: Coordinate = Coordinate(latitude: 50.0, longitude: 9.0),
                                maximum: Coordinate = Coordinate(latitude: 52.0, longitude: 10.0)) -> BoundingBox
    {
        return BoundingBox(minimum: minimum, maximum: maximum)
    }
}
