//
//  OverpassQueryExecuting.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// The result of an Overpass query request.
typealias OverpassQueryResult = Result<[(Element, ElementGeometry?)], Error>

/// An object that executes Overpass queries
protocol OverpassQueryExecuting {
    /// Executes the given `query` against the Overpass API, parses the result and passes it to the `completion` closure.
    /// - Parameters:
    ///   - query: The `OverpassQuery` to execute.
    ///   - completion: Closure that is executed as soon as the API has sent a response and it was parsed.
    func execute(query: OverpassQuery, completion: @escaping (OverpassQueryResult) -> Void)
}
