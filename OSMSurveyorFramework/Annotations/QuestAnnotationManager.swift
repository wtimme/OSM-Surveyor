//
//  QuestAnnotationManager.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol QuestAnnotationManagerDelegate {
    func addAnnotations(_ annotations: [Annotation])
}

public protocol QuestAnnotationManaging {
    func mapDidUpdatePosition(to boundingBox: BoundingBox)
}

public final class QuestAnnotationManager {
}

extension QuestAnnotationManager: QuestAnnotationManaging {
    public func mapDidUpdatePosition(to boundingBox: BoundingBox) {
        /// TODO: Implement me.
    }
}
