//
//  MapViewQuestDownloader.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 01.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public enum MapViewQuestDownloadError: Error {
    case screenAreaTooLarge
}

public protocol MapViewQuestDownloading {
    func downloadQuests(in boundingBox: BoundingBox) throws
}

public final class MapViewQuestDownloader {
    public static let shared = MapViewQuestDownloader()
    
    // MARK: Private properties
    
    private let questTileZoom: Int
    private let minimumDownloadableAreaInSquareKilometers: Double
    private let maximumDownloadableAreaInSquareKilometers: Double
    
    init(questTileZoom: Int = 14,
         minimumDownloadableAreaInSquareKilometers: Double = 1,
         maximumDownloadableAreaInSquareKilometers: Double = 20) {
        self.questTileZoom = questTileZoom
        self.minimumDownloadableAreaInSquareKilometers = minimumDownloadableAreaInSquareKilometers
        self.maximumDownloadableAreaInSquareKilometers = maximumDownloadableAreaInSquareKilometers
    }
}

extension MapViewQuestDownloader: MapViewQuestDownloading {
    public func downloadQuests(in boundingBox: BoundingBox) throws {
        let boundingBoxOfEnclosingTiles = boundingBox.asBoundingBoxOfEnclosingTiles(zoom: 14)
        let areaInSquareKilometers = boundingBoxOfEnclosingTiles.enclosedArea() / 1000000
        
        guard areaInSquareKilometers <= maximumDownloadableAreaInSquareKilometers else {
            throw MapViewQuestDownloadError.screenAreaTooLarge
        }
        
        /// TODO: Implement me
    }
}
