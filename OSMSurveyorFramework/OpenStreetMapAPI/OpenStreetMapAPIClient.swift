//
//  OpenStreetMapAPIClient.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Alamofire
import Foundation
import OAuthSwift
import OAuthSwiftAlamofire

public struct UserDetails {
    public let username: String

    public init(username: String) {
        self.username = username
    }
}

public protocol OpenStreetMapAPIClientProtocol {
    /// Fetches the details of the user that is authenticated with the given credentials.
    ///
    /// Use this method to verify that OAuth credentials are still valid.
    /// - Parameters:
    ///   - oAuthToken: The token for OAuth.
    ///   - oAuthTokenSecret: The token's secret for OAuth.
    ///   - completion: Closure that is executed as soon as the user details were retrieved or an error occurred..
    func userDetails(oAuthToken: String,
                     oAuthTokenSecret: String,
                     completion: @escaping (Result<UserDetails, Error>) -> Void)

    /// Fetches the permissions that the user has granted the app.
    ///
    /// Use this method to verify that the user has given the app all required permissions before saving the credentials.
    /// - Parameters:
    ///   - oAuthToken: The token for OAuth.
    ///   - oAuthTokenSecret: The token's secret for OAuth.
    ///   - completion: Closure that is executed as soon as the permissions were retrieved or an error occurred.
    func permissions(oAuthToken: String,
                     oAuthTokenSecret: String,
                     completion: @escaping (Result<[Permission], Error>) -> Void)
}

public final class OpenStreetMapAPIClient {
    // MARK: Private properties

    private let baseURL: URL

    private let oAuthConsumerKey: String
    private let oAuthConsumerSecret: String

    /// A temporary `Session` that is being used to call the API when checking the OAuth credentials.
    private var temporarySession: Session?

    // MARK: Initializer

    init(baseURL: URL,
         oAuthConsumerKey: String,
         oAuthConsumerSecret: String)
    {
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
                            completion: @escaping (Result<UserDetails, Error>) -> Void)
    {
        let session = temporarySession(oAuthToken: oAuthToken, oAuthTokenSecret: oAuthTokenSecret)

        let url = baseURL.appendingPathComponent("/api/0.6/user/details")
        session.request(url).response(completionHandler: { [weak self] response in
            guard let self = self else { return }

            /// Since the request has finished, the session can be removed.
            self.temporarySession = nil

            if let error = response.error {
                completion(.failure(error))
            } else if
                let responseData = response.data,
                let responseString = String(data: responseData, encoding: .utf8),
                let displayName = self.displayName(from: responseString)
            {
                completion(.success(UserDetails(username: displayName)))
            } else {
                assertionFailure("No error, but unable to read display name from response.")
            }
        })
    }

    /// Parses the display_name from the given XML string.
    ///
    /// I do realize that this is not an optimal solution, but it works for now. Later, we can add an auto-generated API client for this, and properly parse the XML,
    /// but for now, this will do.
    /// - Parameter xmlString: The XML string to parse the display name from.
    /// - Returns: The display name, if available.
    private func displayName(from xmlString: String) -> String? {
        let pattern = #"display_name="([^"]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }

        if let match = regex.firstMatch(in: xmlString, options: [], range: NSRange(location: 0, length: xmlString.utf16.count)) {
            if let range = Range(match.range(at: 1), in: xmlString) {
                return String(xmlString[range])
            }
        }

        return nil
    }

    public func permissions(oAuthToken: String, oAuthTokenSecret: String, completion: @escaping (Result<[Permission], Error>) -> Void) {
        let session = temporarySession(oAuthToken: oAuthToken, oAuthTokenSecret: oAuthTokenSecret)

        let url = baseURL.appendingPathComponent("/api/0.6/permissions")
        session.request(url).response(completionHandler: { [weak self] response in
            guard let self = self else { return }

            /// Since the request has finished, the session can be removed.
            self.temporarySession = nil

            if let error = response.error {
                completion(.failure(error))
            } else if
                let responseData = response.data,
                let responseString = String(data: responseData, encoding: .utf8)
            {
                let permissions = self.permissions(from: responseString)
                completion(.success(permissions))
            } else {
                assertionFailure("No error, but unable to read permissions from response.")
            }
        })
    }

    /// Parses the permissions from the given XML string.
    ///
    /// I do realize that this is not an optimal solution, but it works for now. Later, we can add an auto-generated API client for this, and properly parse the XML,
    /// but for now, this will do.
    /// - Parameter xmlString: The XML string to parse the permissions from.
    /// - Returns: The permissions the user has given the app, if available.
    private func permissions(from xmlString: String) -> [Permission] {
        let pattern = #"permission name="([^"]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }

        var permissions = [String]()

        let nsrange = NSRange(xmlString.startIndex ..< xmlString.endIndex, in: xmlString)
        regex.enumerateMatches(in: xmlString, options: [], range: nsrange) { match, _, _ in
            guard let match = match else { return }

            if let range = Range(match.range(at: 1), in: xmlString) {
                let permission = String(xmlString[range])

                permissions.append(permission)
            }
        }

        return permissions.compactMap { Permission(rawValue: $0) }
    }

    private func temporarySession(oAuthToken: String, oAuthTokenSecret: String) -> Session {
        /// Setup a (temporary) `Session` for fetching the user details.
        let oAuthSwift = OAuth1Swift(consumerKey: oAuthConsumerKey, consumerSecret: oAuthConsumerSecret)

        oAuthSwift.client.credential.oauthToken = oAuthToken
        oAuthSwift.client.credential.oauthTokenSecret = oAuthTokenSecret
        let session = Session(interceptor: OAuthSwiftRequestInterceptor(oAuthSwift))

        /// Store a reference to the `Session`. Otherwise, the request(s) get cancelled.
        temporarySession = session

        return session
    }
}
