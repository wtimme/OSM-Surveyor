//
//  TangramAnnotationLayer.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 09.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import OSMSurveyorFramework
import TangramMap

class TangramAnnotationLayer {
    // MARK: Public properties

    static let Name = "streetcomplete_quests"

    // MARK: Private properties

    private let mapData: TGMapData
    private var features = [TGMapFeature]()

    init(mapData: TGMapData) {
        self.mapData = mapData
    }
}

extension TangramAnnotationLayer: AnnotationLayerProtocol {
    func setAnnotations(_ annotations: [Annotation]) {
        guard !annotations.isEmpty else {
            mapData.clear()
            return
        }

        features = annotations.map { singleAnnotation in
            let coordinate = CLLocationCoordinate2D(latitude: singleAnnotation.coordinate.latitude,
                                                    longitude: singleAnnotation.coordinate.longitude)

            let properties = [
                "type": "point",
                "kind": "ic_quest_bench",
                "osm_type": singleAnnotation.elementType,
                "osm_id": "\(singleAnnotation.elementId)",
                "quest_group": "OSM",
                "quest_id": "-1",
            ]

            return TGMapFeature(point: coordinate, properties: properties)
        }

        mapData.setFeatures(features)
    }
}
