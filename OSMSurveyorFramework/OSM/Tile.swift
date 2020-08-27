//
//  Tile.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct Tile {
    let x: Int
    let y: Int
}

extension Tile: Equatable {}

extension Tile {
    func asBoundingBox(zoom: Int) -> BoundingBox {
        let minimum = Coordinate(latitude: Tile.tile2lat(y: y + 1, zoom: zoom),
                                 longitude: Tile.tile2lon(x: x, zoom: zoom))
        let maximum = Coordinate(latitude: Tile.tile2lat(y: y, zoom: zoom),
                                 longitude: Tile.tile2lon(x: x + 1, zoom: zoom))

        return BoundingBox(minimum: minimum,
                           maximum: maximum)
    }

    static func tile2lat(y: Int, zoom: Int) -> Double {
        return atan(sinh(.pi - 2.0 * .pi * Double(y) / Double(Tile.numberOfTiles(zoom: zoom)))).toDegrees()
    }

    static func tile2lon(x: Int, zoom: Int) -> Double {
        return Double(x) / Double(Tile.numberOfTiles(zoom: zoom)) * 360.0 - 180.0
    }

    static func numberOfTiles(zoom: Int) -> Int {
        return 1 << zoom
    }
}

extension Sequence where Iterator.Element == Tile {
    /// Returns the minimum rectangle of tiles that encloses all the tiles
    func minTileRect() -> TilesRect? {
        guard
            let right = max(by: { $0.x < $1.x })?.x,
            let left = min(by: { $0.x < $1.x })?.x,
            let bottom = max(by: { $0.y < $1.y })?.y,
            let top = min(by: { $0.y < $1.y })?.y
        else {
            return nil
        }

        return TilesRect(left: left, top: top, right: right, bottom: bottom)
    }
}
