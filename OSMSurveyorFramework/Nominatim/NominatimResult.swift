//
//  NominatimResult.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// Result from the Nominatim location search.
public struct NominatimResult {
    public let display_name: String
    public let latitude: Double
    public let longitude: Double
}
