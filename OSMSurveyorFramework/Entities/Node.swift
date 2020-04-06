//
//  Node.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct Node: Element {
    let type: ElementGeometry.ElementType = .node
    let id: Int
    let coordinate: Coordinate
    let version: Int
    let tags: [String: String]
}

extension Node: Equatable {}
