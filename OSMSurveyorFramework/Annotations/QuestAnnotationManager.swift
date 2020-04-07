//
//  QuestAnnotationManager.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol QuestAnnotationManaging {
    var delegate: QuestAnnotationManagerDelegate? { get set }
    
    func mapDidUpdatePosition(to boundingBox: BoundingBox)
}

public final class QuestAnnotationManager {
    // MARK: Public properties
    public static let shared: QuestAnnotationManaging = {
        let fullQuestsDataProvider = FullQuestsViewHelper()
        
        return QuestAnnotationManager(fullQuestsDataProvider: fullQuestsDataProvider)
    }()
    
    public weak var delegate: QuestAnnotationManagerDelegate?
    
    // MARK: Private properties
    private let zoomForDownloadedTiles: Int
    private let fullQuestsDataProvider: FullQuestsDataProviding
    
    /// The tiles that have already been retrieved from the database.
    private var retrievedTiles = [Tile]()
    
    // MARK: Initializer
    init(zoomForDownloadedTiles: Int = 14,
         fullQuestsDataProvider: FullQuestsDataProviding) {
        self.zoomForDownloadedTiles = zoomForDownloadedTiles
        self.fullQuestsDataProvider = fullQuestsDataProvider
    }
}

extension QuestAnnotationManager: QuestAnnotationManaging {
    public func mapDidUpdatePosition(to boundingBox: BoundingBox) {
        guard let delegate = delegate else { return }
        
        let tilesRect = boundingBox.enclosingTilesRect(zoom: zoomForDownloadedTiles)
        let tiles = tilesRect.tiles()
        let tilesNotYetRetrieved = tiles.filter { !retrievedTiles.contains($0) }
        
        guard let minTilesRect = tilesNotYetRetrieved.minTileRect() else {
            /// All tiles have already been retrieved; nothing to do here.
            return
        }
        
        let quests = fullQuestsDataProvider.findQuests(in: minTilesRect.asBoundingBox(zoom: zoomForDownloadedTiles))
        
        retrievedTiles.append(contentsOf: minTilesRect.tiles())
        
        guard !quests.isEmpty else { return }
        
        let annotations = quests.map { Annotation(coordinate: $0.coordinate) }
        
        delegate.addAnnotations(annotations)
    }
}
