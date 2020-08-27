//
//  AddBusStopShelterQuest.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

final class AddBusStopShelterQuest: OverpassQuest {
    func query(boundingBox: BoundingBox) -> OverpassQuery {
        let queryWithPlaceholder = """
        (
          node["public_transport"="platform"]["shelter"!~".*"]({{bbox}});
          node["highway"="bus_stop"]["public_transport"!="stop_position"]["shelter"!~".*"]({{bbox}});
        );
        """

        let queryWithBoundingBox = queryWithPlaceholder.replacingOccurrences(of: "{{bbox}}", with: boundingBox.toOverpassBoundingBox())

        return """
        [out:json];
        \(queryWithBoundingBox)
        out meta;
        """
    }
}
