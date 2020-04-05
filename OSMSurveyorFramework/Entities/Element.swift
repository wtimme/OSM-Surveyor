//
//  Element.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol Element {
    var type: ElementGeometry.ElementType { get }    
    var id: Int64 { get }
    var version: Int64 { get }
    var tags: [String: String] { get }
}
