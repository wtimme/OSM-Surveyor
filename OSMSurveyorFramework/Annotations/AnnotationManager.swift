//
//  AnnotationManager.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol AnnotationManaging {
    var delegate: AnnotationManagerDelegate? { get set }

    func mapDidUpdatePosition(to boundingBox: BoundingBox)
}

public final class AnnotationManager {
    // MARK: Public properties

    public static let shared: AnnotationManaging = {
        let fullQuestsDataProvider = FullQuestsViewHelper()

        return AnnotationManager(fullQuestsDataProvider: fullQuestsDataProvider)
    }()

    public weak var delegate: AnnotationManagerDelegate?

    // MARK: Private properties

    private let zoomForDownloadedTiles: Int
    private let fullQuestsDataProvider: FullQuestsDataProviding

    /// The maximum area in square kilometers in which the data provider is queried for quests.
    /// This limit is set here mainly for performance reasons, since without it, the app might crash.
    /// It is not calculated. Rather, it was decided on after some manual testing with an actual device.
    private let maximumQueryAreaInSquareKilometers: Double

    /// The tiles that have already been retrieved from the database.
    private var retrievedTiles = [Tile]()

    /// All annotations that have already been retrieved.
    private var allAnnotations = [Annotation]()

    // MARK: Initializer

    init(zoomForDownloadedTiles: Int = 14,
         maximumQueryAreaInSquareKilometers: Double = 20,
         fullQuestsDataProvider: FullQuestsDataProviding)
    {
        self.zoomForDownloadedTiles = zoomForDownloadedTiles
        self.maximumQueryAreaInSquareKilometers = maximumQueryAreaInSquareKilometers
        self.fullQuestsDataProvider = fullQuestsDataProvider
    }
}

extension AnnotationManager: AnnotationManaging {
    public func mapDidUpdatePosition(to boundingBox: BoundingBox) {
        guard let delegate = delegate else { return }

        guard boundingBox.enclosedAreaInSquareKilometers() <= maximumQueryAreaInSquareKilometers else {
            /// The area is too large; don't query the database.
            return
        }

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

        let annotations = quests.map { Annotation(elementType: $0.elementType, elementId: $0.elementId, coordinate: $0.coordinate) }

        allAnnotations.append(contentsOf: annotations)

        delegate.setAnnotations(allAnnotations)
    }
}
