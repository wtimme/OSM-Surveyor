//
//  NominatimResultProvider.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public protocol NominatimResultProviding {
    func performSearch(_ term: String, completion: (Result<[NominatimResult], Error>) -> Void)
}

public class NominatimResultProvider: NominatimResultProviding {
    public init() {}

    public func performSearch(_ term: String, completion: (Result<[NominatimResult], Error>) -> Void) {
        let trimmedTerm = term.trimmingCharacters(in: .whitespaces)

        /// Make sure the term is not empty.
        guard trimmedTerm.count > 0 else { return }

        guard
            let escapedTerm = trimmedTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://nominatim.openstreetmap.org/?addressdetails=0&q=\(escapedTerm)&format=json")
        else {
            return
        }

        // TODO: Actually perform the request.
        print(url.absoluteString)
        completion(.success([]))
    }
}
