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
    func fetchElements(query: String, _ completion: @escaping (Result<[(Element, ElementGeometry?)], Error>) -> Void)
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
    func fetchElements(query: String, _ completion: @escaping (Result<[(Element, ElementGeometry?)], Error>) -> Void) {
        client.fetchElements(query: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(elements):
                self.processElements(Array(elements.values)) { processedElements in
                    completion(.success(processedElements))
                }
            }
        }
    }
    
    private func processElements(_ overpassElements: [OPElement], completion: @escaping ([(Element, ElementGeometry?)]) -> Void) {
        /// TODO: Implement me.
    }
}
