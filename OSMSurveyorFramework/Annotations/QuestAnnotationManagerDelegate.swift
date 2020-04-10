//
//  QuestAnnotationManagerDelegate.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol QuestAnnotationManagerDelegate: class {
    func setAnnotations(_ annotations: [Annotation])
}
