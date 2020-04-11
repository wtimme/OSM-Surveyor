//
//  OpenStreetMapAPIClient.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

public struct UserDetails {
    public let username: String
    
    public init(username: String) {
        self.username = username
    }
}

public protocol OpenStreetMapAPIClientProtocol {
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

public final class OpenStreetMapAPIClient {
    // MARK: Private properties
    
    private let baseURL: URL
    
    private let oAuthConsumerKey: String
    private let oAuthConsumerSecret: String
    
    // MARK: Initializer
    
    init(baseURL: URL,
         oAuthConsumerKey: String,
         oAuthConsumerSecret: String) {
        self.baseURL = baseURL
        self.oAuthConsumerKey = oAuthConsumerKey
        self.oAuthConsumerSecret = oAuthConsumerSecret
    }
    
    /// Initializes the handler with the path to a Property List file in which the OAuth secrets can be found.
    /// - Parameter propertyListPath: Path to a Property List file that contains the OAuth secrets.
    public convenience init?(propertyListPath: String) {
        guard let url = URL(string: "https://api.openstreetmap.org") else { return nil }
        
        guard
            let propertiesAsDictionary = NSDictionary(contentsOfFile: propertyListPath),
            let consumerKey = propertiesAsDictionary.object(forKey: "OSM_OAuth_ConsumerKey") as? String,
            let consumerSecret = propertiesAsDictionary.object(forKey: "OSM_OAuth_ConsumerSecret") as? String
        else {
            assertionFailure("Unable to read OAuth secrets from file \(propertyListPath)")
            return nil
        }
        
        self.init(baseURL: url,
                  oAuthConsumerKey: consumerKey,
                  oAuthConsumerSecret: consumerSecret)
    }
}

extension OpenStreetMapAPIClient: OpenStreetMapAPIClientProtocol {
    public func userDetails(oAuthToken: String,
                     oAuthTokenSecret: String,
                     completion: @escaping (Result<UserDetails, Error>) -> Void) {
        /// TODO: Implement me.
    }
}
