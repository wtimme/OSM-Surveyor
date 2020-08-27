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

extension Coordinate: Hashable {}

extension Coordinate: Codable {}

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
    func distance(to otherCoordinate: Coordinate, globeRadius: Double = 6_371_000.0) -> Double {
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

extension Coordinate {
    /**
     Return a bounding box that contains a circle with the given radius around this point. In
     other words, it is a square centered at the given position and with a side length of radius*2.
     */
    public func enclosingBoundingBox(radius: Double, globeRadius: Double = 6_371_000) -> BoundingBox {
        let distance = sqrt(2) * radius

        let minimum = translate(distance: distance, angle: 225, globeRadius: globeRadius)
        let maximum = translate(distance: distance, angle: 45, globeRadius: globeRadius)

        return BoundingBox(minimum: minimum, maximum: maximum)
    }

    /// Returns a new point in the given distance and angle from the this point
    private func translate(distance: Double, angle: Double, globeRadius: Double = 6_371_000) -> Coordinate {
        let pair = translate(φ1: latitude.toRadians(),
                             λ1: longitude.toRadians(),
                             α1: angle.toRadians(),
                             distance: distance,
                             radius: globeRadius)

        return Coordinate.createTranslated(latitude: pair.0.toDegrees(),
                                           longitude: pair.1.toDegrees())
    }

    private func translate(φ1: Double, λ1: Double, α1: Double, distance: Double, radius: Double) -> (Double, Double) {
        let σ12 = distance / radius
        let y = sin(φ1) * cos(σ12) + cos(φ1) * sin(σ12) * cos(α1)
        let a = cos(φ1) * cos(σ12) - sin(φ1) * sin(σ12) * cos(α1)
        let b = sin(σ12) * sin(α1)
        let x = sqrt(pow(a, 2) + pow(b, 2))
        let φ2 = atan2(y, x)
        let λ2 = λ1 + atan2(b, a)

        return (φ2, λ2)
    }

    private static func createTranslated(latitude: Double, longitude: Double) -> Coordinate {
        var resultingLatitude = latitude
        var resultingLongitude = longitude

        resultingLongitude = Coordinate.normalizeLongitude(resultingLongitude)

        let crossedPole: Bool
        if resultingLatitude > 90 {
            // North pole
            resultingLatitude = 180 - resultingLatitude
            crossedPole = true
        } else if resultingLatitude < -90 {
            resultingLatitude = -180 - resultingLatitude
            crossedPole = true
        } else {
            crossedPole = false
        }

        if crossedPole {
            resultingLongitude += 180

            if resultingLongitude > 180 {
                resultingLongitude -= 360
            }
        }

        return Coordinate(latitude: resultingLatitude, longitude: resultingLongitude)
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
