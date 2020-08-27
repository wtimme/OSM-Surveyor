//
//  Permission.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// Permissions that the user can give an OAuth consumer.
///
/// See: https://wiki.openstreetmap.org/wiki/API_v0.6#Retrieving_permissions:_GET_.2Fapi.2F0.6.2Fpermissions
public enum Permission: String {
    /// Read user preferences
    case allow_read_prefs

    /// Modify user preferences
    case allow_write_prefs

    /// Create diary entries, comments and make friends
    case allow_write_diary

    /// Modify the map
    case allow_write_api

    /// Read private GPS traces
    case allow_read_gpx

    /// Upload GPS traces
    case allow_write_gpx

    /// Modify notes
    case allow_write_notes
}
