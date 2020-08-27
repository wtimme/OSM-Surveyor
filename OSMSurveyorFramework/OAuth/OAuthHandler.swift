//
//  OAuthHandler.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import OAuthSwift

public typealias OAuthAuthorizationResult = Result<(token: String, tokenSecret: String), Error>

public protocol OAuthHandling {
    func authorize(from viewController: Any, completion: @escaping (OAuthAuthorizationResult) -> Void)

    /// Asks the handler to handle the given `URL`.
    /// - Parameter url: The `URL` to handle.
    func handle(url: URL)
}

public final class OAuthHandler {
    // MARK: Public properties

    /// Singleton instance. Is only available if the `OAuthHandler` has been initialized from somewhere.
    /// This is is far from ideal, but since the framework lacks a proper injection mechanism, this is a quick hack to have access to a shared instance.
    public private(set) static var shared: OAuthHandling?

    // MARK: Private properties

    private let oauthswift: OAuth1Swift

    // MARK: Initializer

    init(consumerKey: String,
         consumerSecret: String,
         requestTokenUrl: String = "https://www.openstreetmap.org/oauth/request_token",
         authorizeUrl: String = "https://www.openstreetmap.org/oauth/authorize",
         accessTokenUrl: String = "https://www.openstreetmap.org/oauth/access_token")
    {
        oauthswift = OAuth1Swift(consumerKey: consumerKey,
                                 consumerSecret: consumerSecret,
                                 requestTokenUrl: requestTokenUrl,
                                 authorizeUrl: authorizeUrl,
                                 accessTokenUrl: accessTokenUrl)

        OAuthHandler.shared = self
    }

    /// Initializes the handler with the path to a Property List file in which the OAuth secrets can be found.
    /// - Parameter propertyListPath: Path to a Property List file that contains the OAuth secrets.
    public convenience init?(propertyListPath: String) {
        guard
            let propertiesAsDictionary = NSDictionary(contentsOfFile: propertyListPath),
            let consumerKey = propertiesAsDictionary.object(forKey: "OSM_OAuth_ConsumerKey") as? String,
            let consumerSecret = propertiesAsDictionary.object(forKey: "OSM_OAuth_ConsumerSecret") as? String
        else {
            assertionFailure("Unable to read OAuth secrets from file \(propertyListPath)")
            return nil
        }

        self.init(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
}

extension OAuthHandler: OAuthHandling {
    public func authorize(from viewController: Any, completion: @escaping (OAuthAuthorizationResult) -> Void) {
        /// Configure OAuthSwift to use SFSafariViewController
        guard let viewController = viewController as? UIViewController else { return }
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)

        guard let callbackURL = URL(string: "osm-surveyor://oauth-callback/osm") else { return }
        oauthswift.authorize(withCallbackURL: callbackURL) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success((credential, _, _)):
                completion(.success((credential.oauthToken, credential.oauthTokenSecret)))
            }
        }
    }

    public func handle(url: URL) {
        OAuthSwift.handle(url: url)
    }
}
