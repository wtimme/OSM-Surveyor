//
//  AnnotationManagerDelegateMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class AnnotationManagerDelegateMock {
    private(set) var didCallSetAnnotations = false
    private(set) var annotations = [Annotation]()
}

extension AnnotationManagerDelegateMock: AnnotationManagerDelegate {
    func setAnnotations(_ annotations: [Annotation]) {
        didCallSetAnnotations = true

        self.annotations = annotations
    }
}
