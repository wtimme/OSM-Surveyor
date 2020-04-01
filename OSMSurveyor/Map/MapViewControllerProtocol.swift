//
//  MapViewControllerProtocol.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 24.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import OSMSurveyorFramework

protocol MapViewControllerProtocol {
    func fly(to position: CameraPosition, duration: TimeInterval)
}
