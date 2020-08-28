//
//  CameraPosition+MakeCameraPosition.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 28.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework

extension CameraPosition {
    static func makeCameraPosition(center: Coordinate = Coordinate(latitude: 51.4583, longitude: -0.0618),
                                   zoom: Double = 9,
                                   bearing: Double = 0,
                                   pitch: Double = 0) -> CameraPosition
    {
        return CameraPosition(center: center,
                              zoom: zoom,
                              bearing: bearing,
                              pitch: pitch)
    }
}
