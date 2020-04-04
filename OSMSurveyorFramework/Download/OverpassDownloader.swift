//
//  OverpassDownloader.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SwiftOverpassAPI

protocol OverpassDownloading {
    func fetchElements(query: String, _ completion: @escaping (Result<[Int: OPElement], Error>) -> Void)
}

class OverpassDownloader {
    // MARK: Private properties
    
    private let client: OPClient
    
    // MARK: Initializer
    
    init(client: OPClient = .init()) {
        self.client = client
    }
}

extension OverpassDownloader: OverpassDownloading {
    func fetchElements(query: String, _ completion: @escaping (Result<[Int : OPElement], Error>) -> Void) {
        client.fetchElements(query: query) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(elements):
                completion(.success(elements))
            }
        }
    }
}
