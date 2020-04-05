//
//  AddBenchBackrestQuest.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

final class AddBenchBackrestQuest: QuestTypeProtocol {
    func download(boundingBox: BoundingBox, using downloader: OverpassDownloading, _ completion: @escaping (Result<[(Element, ElementGeometry?)], Error>) -> Void) {
        let queryWithPlaceholder = """
        node["amenity"="bench"]["backrest"!~".*"]{{bbox}};
        """
        
        let queryWithBoundingBox = queryWithPlaceholder.replacingOccurrences(of: "{{bbox}}", with: boundingBox.toOverpassBoundingBoxFilter())
        
        let query = """
        [out:json];
        \(queryWithBoundingBox)
        out;
        """
        
        downloader.fetchElements(query: query, completion)
    }
}
