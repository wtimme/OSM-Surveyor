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
                let processedElements = self.processElements(Array(elements.values))

                completion(.success(processedElements))
            }
        }
    }

    private func processElements(_ overpassElements: [OPElement]) -> [(Element, ElementGeometry?)] {
        return overpassElements.compactMap { singleElement in
            guard case let .center(coordinate) = singleElement.geometry else {
                /// At the moment, the app only supports nodes.
                // TODO: Add handling for other geometries.
                return nil
            }

            let resultingElement = Node(id: singleElement.id,
                                        coordinate: Coordinate(latitude: coordinate.latitude,
                                                               longitude: coordinate.longitude),
                                        version: singleElement.meta?.version ?? -1,
                                        tags: singleElement.tags)

            let elementGeometry = ElementGeometry(type: .node,
                                                  elementId: singleElement.id,
                                                  polylines: nil,
                                                  polygons: nil,
                                                  center: Coordinate(latitude: coordinate.latitude,
                                                                     longitude: coordinate.longitude))
            return (resultingElement, elementGeometry)
        }
    }
}

extension OverpassDownloader: OverpassQueryExecuting {
    func execute(query: OverpassQuery, completion: @escaping (OverpassQueryResult) -> Void) {
        client.fetchElements(query: query) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(elements):
                let processedElements = self.processElements(Array(elements.values))

                completion(.success(processedElements))
            }
        }
    }
}
