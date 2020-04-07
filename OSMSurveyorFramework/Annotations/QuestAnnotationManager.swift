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
    
    // MARK: Initializer
    init(zoomForDownloadedTiles: Int = 14,
         fullQuestsDataProvider: FullQuestsDataProviding) {
        self.zoomForDownloadedTiles = zoomForDownloadedTiles
        self.fullQuestsDataProvider = fullQuestsDataProvider
    }
}

extension QuestAnnotationManager: QuestAnnotationManaging {
    public func mapDidUpdatePosition(to boundingBox: BoundingBox) {
    }
}
