//
//  OpenStreetMapAPIClient.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct UserDetails {
    let username: String
}

protocol OpenStreetMapAPIClientProtocol {
    /// Fetches the details of the user that is authenticated with the given credentials.
    /// Use this method to verify that OAuth credentials are still valid.
    /// - Parameters:
    ///   - oAuthToken: The token for OAuth.
    ///   - oAuthTokenSecret: The token's secret for OAuth.
    ///   - completion: Closure that is executed as soon as the user details were retrieved or an error occurred..
    func userDetails(oAuthToken: String,
                     oAuthTokenSecret: String,
                     completion: @escaping (Result<UserDetails, Error>) -> Void)
}
