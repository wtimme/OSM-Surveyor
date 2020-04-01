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
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Coordinate: Equatable {}

extension Coordinate {
    static let minimumValue = Coordinate(latitude: -90, longitude: -180)
    static let maximumValue = Coordinate(latitude: 90, longitude: 180)
}

extension Coordinate {
    func enclosingTile(zoom: Int) -> Tile {
        return Tile(x: lon2tile(lon: (longitude + 180).truncatingRemainder(dividingBy: 360) - 180, zoom: zoom),
                    y: lat2tile(lat: latitude, zoom: zoom))
    }
    
    private func lat2tile(lat: Double, zoom: Int) -> Int {
        return Int(Double(Tile.numberOfTiles(zoom: zoom)) * (1 - asinh(tan(lat.toRadians())) / .pi) / 2)
    }
    
    private func lon2tile(lon: Double, zoom: Int) -> Int {
        return Int(Double(Tile.numberOfTiles(zoom: zoom)) * (lon + 180) / 360)
    }
}
