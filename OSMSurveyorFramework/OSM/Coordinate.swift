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

extension Coordinate {
    func distance(to otherCoordinate: Coordinate, globeRadius: Double = 6371000.0) -> Double {
        return measuredLength(
            latitude.toRadians(),
            longitude.toRadians(),
            otherCoordinate.latitude.toRadians(),
            otherCoordinate.longitude.toRadians(),
            globeRadius
        )
    }
    
    /// Returns the distance of two points on a sphere with the given radius
    ///
    /// See https://mathforum.org/library/drmath/view/51879.html for derivation
    private func measuredLength(_ φ1: Double, _ λ1: Double, _ φ2: Double, _ λ2: Double, _ r: Double) -> Double {
        let Δλ = λ2 - λ1
        let Δφ = φ2 - φ1
        let a = pow(sin(Δφ / 2), 2) + cos(φ1) * cos(φ2) * pow(sin(Δλ / 2), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return c * r
    }
    
    static func normalizeLongitude(_ longitude: Double) -> Double {
        var normalizedLongitude = longitude
        
        while normalizedLongitude > 180 {
            normalizedLongitude -= 360
        }
        
        while normalizedLongitude < -180 {
            normalizedLongitude += 360
        }
        
        return normalizedLongitude
    }
}

public extension Sequence where Iterator.Element == Coordinate {
    /// Returns a bounding box that contains all points
    var enclosingBoundingBox: BoundingBox? {
        var iterator = makeIterator()
        
        guard let origin = iterator.next() else {
            assertionFailure("The list of coordinates is empty.")
            return nil
        }
        
        var minLatOffset: Double = 0
        var minLonOffset: Double = 0
        var maxLatOffset: Double = 0
        var maxLonOffset: Double = 0
        
        while let pos = iterator.next() {
            // calculate with offsets here to properly handle 180th meridian
            let latitude = pos.latitude - origin.latitude
            let longitude = Coordinate.normalizeLongitude(pos.longitude - origin.longitude)
            
            if latitude < minLatOffset { minLatOffset = latitude }
            if longitude < minLonOffset { minLonOffset = longitude }
            if latitude > maxLatOffset { maxLatOffset = latitude }
            if longitude > maxLonOffset { maxLonOffset = longitude }
        }
        
        return BoundingBox(minimum: Coordinate(latitude: origin.latitude + minLatOffset,
                                               longitude: Coordinate.normalizeLongitude(origin.longitude + minLonOffset)),
                           maximum: Coordinate(latitude: origin.latitude + maxLatOffset,
                                               longitude: Coordinate.normalizeLongitude(origin.longitude + maxLonOffset)))
    }
}
