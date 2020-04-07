//
//  QuestAnnotationManager.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol QuestAnnotationManagerDelegate: class {
    func addAnnotations(_ annotations: [Annotation])
}

public protocol QuestAnnotationManaging {
    var delegate: QuestAnnotationManagerDelegate? { get set }
    
    func mapDidUpdatePosition(to boundingBox: BoundingBox)
}

public final class QuestAnnotationManager {
    // MARK: Public properties
    public static let shared: QuestAnnotationManaging = QuestAnnotationManager()
    public weak var delegate: QuestAnnotationManagerDelegate?
}

extension QuestAnnotationManager: QuestAnnotationManaging {
    public func mapDidUpdatePosition(to boundingBox: BoundingBox) {
        /// TODO: Implement me.
        let coordinates = [Coordinate(latitude: 53.55232, longitude: 9.99554),
                           Coordinate(latitude: 53.55289, longitude: 9.99704)]
        
        let annotations = coordinates.map { Annotation(coordinate: $0) }
        
        delegate?.addAnnotations(annotations)
    }
}
