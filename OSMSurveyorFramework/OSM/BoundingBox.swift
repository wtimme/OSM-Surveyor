//
//  BoundingBox.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct BoundingBox {
    public let minimum: Coordinate
    public let maximum: Coordinate

    public init(minimum: Coordinate, maximum: Coordinate) {
        self.minimum = minimum
        self.maximum = maximum
    }
}

extension BoundingBox {
    func toOverpassBoundingBoxFilter() -> String {
        return "(\(toOverpassBoundingBox()))"
    }

    func toOverpassBoundingBox() -> String {
        let formatter = NumberFormatter()

        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 340

        let valuesAsNumbers = [minimum.latitude, minimum.longitude, maximum.latitude, maximum.longitude].map { NSNumber(floatLiteral: $0) }
        let valuesAsStrings = valuesAsNumbers.compactMap { formatter.string(from: $0) }

        return valuesAsStrings.joined(separator: ",")
    }
}

extension BoundingBox {
    /**
     Returns the bounding box of the tile rect at the given zoom level that encloses this bounding box.
     In other words, it expands this bounding box to fit to the tile boundaries.
     If this bounding box crosses the 180th meridian, it'll take only the first half of the bounding box
     */
    func asBoundingBoxOfEnclosingTiles(zoom: Int) -> BoundingBox {
        return enclosingTilesRect(zoom: zoom).asBoundingBox(zoom: zoom)
    }

    func enclosingTilesRect(zoom: Int) -> TilesRect {
        if crosses180thMeridian() {
            guard let firstBoundingBox = splitAt180thMeridian().first else {
                assertionFailure("Failed to get the bounding box.")

                return TilesRect(left: 0, top: 0, right: 0, bottom: 0)
            }

            return firstBoundingBox.enclosingTilesRectOfBBoxNotCrossing180thMeridian(zoom: zoom)
        } else {
            return enclosingTilesRectOfBBoxNotCrossing180thMeridian(zoom: zoom)
        }
    }

    private func crosses180thMeridian() -> Bool {
        return minimum.longitude > maximum.longitude
    }

    private func splitAt180thMeridian() -> [BoundingBox] {
        if crosses180thMeridian() {
            return [
                BoundingBox(minimum: minimum, maximum: Coordinate(latitude: maximum.latitude, longitude: Coordinate.maximumValue.longitude)),
                BoundingBox(minimum: Coordinate(latitude: minimum.latitude, longitude: Coordinate.minimumValue.longitude), maximum: maximum),
            ]
        }

        return [self]
    }

    private func enclosingTilesRectOfBBoxNotCrossing180thMeridian(zoom: Int) -> TilesRect {
        /**
         TilesRect.asBoundingBox returns a bounding box that intersects in line with the neighbouring
         tiles to ensure that there is no space between the tiles. So when converting a bounding box
         that exactly fits a tiles rect back to a tiles rect, it must be made smaller by the tiniest
         amount
         */
        let notTheNextTile = 1e-7
        let min = Coordinate(latitude: minimum.latitude + notTheNextTile, longitude: minimum.longitude + notTheNextTile)
        let max = Coordinate(latitude: maximum.latitude - notTheNextTile, longitude: maximum.longitude - notTheNextTile)
        let minTile = min.enclosingTile(zoom: zoom)
        let maxTile = max.enclosingTile(zoom: zoom)

        return TilesRect(left: minTile.x, top: maxTile.y, right: maxTile.x, bottom: minTile.y)
    }
}

extension BoundingBox {
    /// Returns the area enclosed by this bounding box
    func enclosedArea(globeRadius: Double = 6_371_000.0) -> Double {
        let minLatMaxLon = Coordinate(latitude: minimum.latitude, longitude: maximum.longitude)
        let maxLatMinLon = Coordinate(latitude: maximum.latitude, longitude: minimum.longitude)

        return minimum.distance(to: minLatMaxLon, globeRadius: globeRadius) * minimum.distance(to: maxLatMinLon, globeRadius: globeRadius)
    }

    func enclosedAreaInSquareKilometers(globeRadius: Double = 6_371_000) -> Double {
        let oneKilometer = 1000
        let oneSquareKilometer = oneKilometer * oneKilometer

        return enclosedArea(globeRadius: globeRadius) / Double(oneSquareKilometer)
    }
}

extension BoundingBox: Equatable {
    public static func == (lhs: BoundingBox, rhs: BoundingBox) -> Bool {
        return lhs.minimum == rhs.minimum && lhs.maximum == rhs.maximum
    }
}
