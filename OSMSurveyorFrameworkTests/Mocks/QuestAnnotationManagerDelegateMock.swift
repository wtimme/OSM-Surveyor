//
//  QuestAnnotationManagerDelegateMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class QuestAnnotationManagerDelegateMock {
    private(set) var didCallAddAnnotations = false
    private(set) var annotations = [Annotation]()
    
    private(set) var didCallSetAnnotations = false
    private(set) var annotationsToSet = [Annotation]()
}

extension QuestAnnotationManagerDelegateMock: QuestAnnotationManagerDelegate {
    func addAnnotations(_ annotations: [Annotation]) {
        didCallAddAnnotations = true
        
        self.annotations = annotations
    }
    
    func setAnnotations(_ annotations: [Annotation]) {
        didCallSetAnnotations = true
        
        self.annotationsToSet = annotations
    }
}
