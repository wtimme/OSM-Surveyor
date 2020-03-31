//
//  BoundingBox.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct BoundingBox {
    let minimum: Coordinate
    let maximum: Coordinate
}

extension BoundingBox {
    
    func toOverpassBoundingBoxFilter() -> String {
        return "(\(toOverpassBoundingBox()))"
    }
    
    private func toOverpassBoundingBox() -> String {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 340
        
        let valuesAsNumbers = [minimum.latitude, minimum.longitude, maximum.latitude, maximum.longitude].map { NSNumber(floatLiteral: $0) }
        let valuesAsStrings = valuesAsNumbers.compactMap { formatter.string(from: $0) }
        
        return valuesAsStrings.joined(separator: ",")
    }

}

extension BoundingBox {
    func enclosingTilesRect(zoom: Int) -> TilesRect {
        if (crosses180thMeridian()) {
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
                BoundingBox(minimum: Coordinate(latitude: minimum.latitude, longitude: Coordinate.minimumValue.longitude), maximum: maximum)
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

extension BoundingBox: Equatable {
    static func == (lhs: BoundingBox, rhs: BoundingBox) -> Bool {
        return lhs.minimum == rhs.minimum && lhs.maximum == rhs.maximum
    }
}
