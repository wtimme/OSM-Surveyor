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
    /// Downloads the quests in the given `BoundingBox`.
    /// - Parameters:
    ///   - boundingBox: The bounding box in which to download the quests.
    ///   - cameraPosition: The current camera position of the map. Will be used to calculate a larger bounding box in case the provided one is too small.
    func downloadQuests(in boundingBox: BoundingBox, cameraPosition: CameraPosition) throws
}

public final class MapViewQuestDownloader {
    public static let shared: MapViewQuestDownloader = {
        let questProvider = QuestProvider(quests: [])
        let downloadedQuestTypesManager = DownloadedTileDataHelper()
        let overpassDownloader = OverpassDownloader()
        
        let questDownloader = QuestDownloader(questProvider: questProvider,
                                              downloadedQuestTypesManager: downloadedQuestTypesManager,
                                              overpassDownloader: overpassDownloader)
        let questController = QuestController(downloader: questDownloader)
        
        let overpassQuestProvider = StaticOverpassQuestProvider()
        let overpassQueryExecutor = overpassDownloader
        let zoomForDownloadedTiles = 14
        let questElementProcessor = QuestElementProcessor(questDataManager: QuestDataHelper())
        
        let questManager = OverpassQuestManager(questProvider: overpassQuestProvider,
                                                queryExecutor: overpassQueryExecutor,
                                                zoomForDownloadedTiles: zoomForDownloadedTiles,
                                                downloadedQuestTypesManager: downloadedQuestTypesManager,
                                                questElementProcessor: questElementProcessor)
        
        return MapViewQuestDownloader(questController: questController,
                                      questManager: questManager)
    }()
    
    // MARK: Private properties
    
    private let questController: QuestControlling
    private let questManager: QuestManaging
    private let questTileZoom: Int
    private let minimumDownloadableAreaInSquareKilometers: Double
    private let maximumDownloadableAreaInSquareKilometers: Double
    private let minimumDownloadRadiusInMeters: Double
    
    init(questController: QuestControlling,
         questManager: QuestManaging,
         questTileZoom: Int = 14,
         minimumDownloadableAreaInSquareKilometers: Double = 1,
         maximumDownloadableAreaInSquareKilometers: Double = 20,
         minimumDownloadRadiusInMeters: Double = 600) {
        self.questController = questController
        self.questManager = questManager
        self.questTileZoom = questTileZoom
        self.minimumDownloadableAreaInSquareKilometers = minimumDownloadableAreaInSquareKilometers
        self.maximumDownloadableAreaInSquareKilometers = maximumDownloadableAreaInSquareKilometers
        self.minimumDownloadRadiusInMeters = minimumDownloadRadiusInMeters
    }
}

extension MapViewQuestDownloader: MapViewQuestDownloading {
    public func downloadQuests(in boundingBox: BoundingBox, cameraPosition: CameraPosition) throws {
        let boundingBoxOfEnclosingTiles = boundingBox.asBoundingBoxOfEnclosingTiles(zoom: 14)
        let areaInSquareKilometers = boundingBoxOfEnclosingTiles.enclosedArea() / 1000000
        
        guard areaInSquareKilometers <= maximumDownloadableAreaInSquareKilometers else {
            throw MapViewQuestDownloadError.screenAreaTooLarge
        }
        
        let boundingBoxToDownload: BoundingBox
        if areaInSquareKilometers < minimumDownloadableAreaInSquareKilometers {
            boundingBoxToDownload = cameraPosition.center.enclosingBoundingBox(radius: minimumDownloadRadiusInMeters)
        } else {
            boundingBoxToDownload = boundingBoxOfEnclosingTiles
        }
        
        questManager.updateQuests(in: boundingBoxToDownload, ignoreDownloadedQuestsBefore: Date(timeIntervalSinceNow: -60 * 60 * 24))
    }
}
