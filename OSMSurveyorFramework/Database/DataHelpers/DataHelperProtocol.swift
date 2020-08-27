//
//  DataHelperProtocol.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

/// Source: https://masteringswift.blogspot.com/2015/09/create-data-access-layer-with.html
protocol DataHelperProtocol {
    associatedtype T
    static var db: Connection? { get set }

    static var table: Table { get }

    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?

    static func item(from row: Row) -> T?
}

extension DataHelperProtocol {
    static func findAll() throws -> [T]? {
        guard let db = db else { return [] }

        do {
            let rows = try db.prepare(table)

            return rows.compactMap(item(from:))
        } catch {
            assertionFailure("Failed to find all: \(error.localizedDescription)")
            return nil
        }
    }
}
