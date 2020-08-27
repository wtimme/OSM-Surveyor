//
//  TilesRect.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct TilesRect {
    let left: Int
    let top: Int
    let right: Int
    let bottom: Int
}

extension TilesRect: Equatable {}

extension TilesRect {
    func asBoundingBox(zoom: Int = 14) -> BoundingBox {
        return BoundingBox(minimum: Coordinate(latitude: Tile.tile2lat(y: bottom + 1, zoom: zoom),
                                               longitude: Tile.tile2lon(x: left, zoom: zoom)),
                           maximum: Coordinate(latitude: Tile.tile2lat(y: top, zoom: zoom),
                                               longitude: Tile.tile2lon(x: right + 1, zoom: zoom)))
    }

    func tiles() -> [Tile] {
        var tiles = [Tile]()

        for y in top ... bottom {
            for x in left ... right {
                tiles.append(Tile(x: x, y: y))
            }
        }

        return tiles
    }

    var size: Int {
        return (bottom - top + 1) * (right - left + 1)
    }
}
