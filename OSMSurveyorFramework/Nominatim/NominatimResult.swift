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
    public let display_name: String
    public let latitude: Double
    public let longitude: Double

    enum CodingKeys: String, CodingKey {
        case display_name
        case latitude = "lat"
        case longitude = "lon"
    }
}

extension NominatimResult {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        display_name = try container.decode(String.self, forKey: .display_name)

        let latitudeAsString = try container.decode(String.self, forKey: .latitude)
        latitude = (latitudeAsString as NSString).doubleValue

        let longitudeAsString = try container.decode(String.self, forKey: .longitude)
        longitude = (longitudeAsString as NSString).doubleValue
    }
}
