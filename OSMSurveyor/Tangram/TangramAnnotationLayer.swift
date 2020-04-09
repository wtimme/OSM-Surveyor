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
    
    static let Name = "OSMSurveyor_quests"
    
    // MARK: Private properties
    
    private let mapData: TGMapData
    
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
        
        let features: [TGMapFeature] = annotations.map { singleAnnotation in
            let coordinate = CLLocationCoordinate2D(latitude: singleAnnotation.coordinate.latitude,
                                                    longitude: singleAnnotation.coordinate.longitude)
            
            let properties = ["type": "point"]
            
            return TGMapFeature(point: coordinate, properties: properties)
        }
        
        mapData.setFeatures(features)
    }
}
