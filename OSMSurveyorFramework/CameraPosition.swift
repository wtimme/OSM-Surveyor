//
//  CameraPosition.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 24.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct CameraPosition {
    public let center: Coordinate
    public let zoom: Double
    public let bearing: Double
    public let pitch: Double

    public init(center: Coordinate, zoom: Double, bearing: Double, pitch: Double) {
        self.center = center
        self.zoom = zoom
        self.bearing = bearing
        self.pitch = pitch
    }
}
