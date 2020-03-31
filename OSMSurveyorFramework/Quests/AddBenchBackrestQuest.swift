//
//  AddBenchBackrestQuest.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SwiftOverpassAPI

final class AddBenchBackrestQuest: QuestTypeProtocol {
    func download(boundingBox: BoundingBox, using downloader: OverpassDownloading, _ completion: @escaping (Result<[Int: OPElement], Error>) -> Void) {
        let queryWithPlaceholder = """
        node["amenity"="bench"]["backrest"!~".*"]({{bbox}});
        """
        
        let query = queryWithPlaceholder.replacingOccurrences(of: "{{bbox}}", with: boundingBox.toOverpassBoundingBoxFilter())
        
        downloader.fetchElements(query: query, completion)
    }
}
