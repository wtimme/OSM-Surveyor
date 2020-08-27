//
//  DownloadedTile.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 28.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// Represents a `Tile` that has already been downloaded.
/// Is used to determine which `questType`s need to be downloaded in an area.
struct DownloadedTile {
    /// The `Tile` that was downloaded.
    let tile: Tile

    /// The type of `Quest` that was downloaded.
    let questType: String

    /// The `Date` at which the tile was last updated.
    let date: Date
}
