//
//  MapViewQuestDownloader.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 01.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol MapViewQuestDownloading {
    func downloadQuests(at cameraPosition: CameraPosition)
}

public final class MapViewQuestDownloader {
    public static let shared = MapViewQuestDownloader()
    
    // MARK: Private properties
    
    private let minimumDownloadableAreaInSquareKilometers: Double
    private let maximumDownloadableAreaInSquareKilometers: Double
    
    init(minimumDownloadableAreaInSquareKilometers: Double = 1,
         maximumDownloadableAreaInSquareKilometers: Double = 20) {
             self.minimumDownloadableAreaInSquareKilometers = minimumDownloadableAreaInSquareKilometers
             self.maximumDownloadableAreaInSquareKilometers = maximumDownloadableAreaInSquareKilometers
    }
}

extension MapViewQuestDownloader: MapViewQuestDownloading {
    
    public func downloadQuests(at cameraPosition: CameraPosition) {
        /// TODO: Implement me
    }
}
