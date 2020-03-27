//
//  Node.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct Node {
    let id: Int64
    let latitude: Double
    let longitude: Double
    let version: Int64
    let tags: [String: String]
}
