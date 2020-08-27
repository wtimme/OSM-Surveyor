//
//  NominatimResult.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// Result from the Nominatim location search.
public struct NominatimResult: Decodable {
    public let displayName: String
    public let latitude: Double
    public let longitude: Double
    public let boundingBox: BoundingBox

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case latitude = "lat"
        case longitude = "lon"
        case boundingBox = "boundingbox"
    }
}

extension NominatimResult {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        displayName = try container.decode(String.self, forKey: .displayName)

        let latitudeAsString = try container.decode(String.self, forKey: .latitude)
        latitude = (latitudeAsString as NSString).doubleValue

        let longitudeAsString = try container.decode(String.self, forKey: .longitude)
        longitude = (longitudeAsString as NSString).doubleValue

        let boundingBoxCoordinatesAsStrings = try container.decode([String].self, forKey: .boundingBox)
        let boundingBoxCoordinates = boundingBoxCoordinatesAsStrings.map { ($0 as NSString).doubleValue }
        boundingBox = BoundingBox(minimum: Coordinate(latitude: boundingBoxCoordinates[0], longitude: boundingBoxCoordinates[2]),
                                  maximum: Coordinate(latitude: boundingBoxCoordinates[1], longitude: boundingBoxCoordinates[3]))
    }
}
