//
//  AddBenchBackrestQuest.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

final class AddBenchBackrestQuest: OverpassQuest {
    func query(boundingBox: BoundingBox) -> OverpassQuery {
        let queryWithPlaceholder = """
        node["amenity"="bench"]["backrest"!~".*"]{{bbox}};
        """

        let queryWithBoundingBox = queryWithPlaceholder.replacingOccurrences(of: "{{bbox}}", with: boundingBox.toOverpassBoundingBoxFilter())

        return """
        [out:json];
        \(queryWithBoundingBox)
        out meta;
        """
    }
}
