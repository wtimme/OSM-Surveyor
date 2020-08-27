//
//  Node+MakeNode.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

extension Node {
    static func makeNode(id: Int = 1,
                         coordinate: Coordinate = Coordinate(latitude: 53.5, longitude: 9.2),
                         version: Int = 2,
                         tags: [String: String] = ["amenity": "bench"]) -> Node
    {
        return Node(id: id,
                    coordinate: coordinate,
                    version: version,
                    tags: tags)
    }
}
