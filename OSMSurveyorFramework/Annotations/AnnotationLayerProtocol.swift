//
//  AnnotationLayerProtocol.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 09.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

public protocol AnnotationLayerProtocol {
    /// Sets the annotations that are supposed be displayed. Removes any previous ones.
    /// - Parameter annotations: The annotations to display.
    func setAnnotations(_ annotations: [Annotation])
}
