//
//  CameraPosition.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 24.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import OSMSurveyorFramework

struct CameraPosition {
    let center: Coordinate
    let zoom: Double
    let bearing: Double
    let pitch: Double
}
