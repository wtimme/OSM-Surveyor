//
//  NodeDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

protocol NodeDataManaging {
    /// Inserts the given `Node`.
    /// - Parameter node: The `Node` to insert.
    func insert(_ node: Node)
}

class NodeDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "osm_nodes"

    static let table = Table(TABLE_NAME)

    static var db: Connection?

    /// Columns
    static let id = Expression<Int>("id")
    static let latitude = Expression<Double>("latitude")
    static let longitude = Expression<Double>("longitude")
    static let version = Expression<Int>("version")
    static let tags = Expression<SQLite.Blob>("tags")

    typealias T = Node

    static func createTable() throws {
        guard let db = db else { return }

        do {
            _ = try db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(latitude)
                t.column(longitude)
                t.column(version)
                t.column(tags)
            })
        } catch {
            assertionFailure("Failed to create table: \(error.localizedDescription)")
        }
    }

    static func insert(item: T) throws -> Int64 {
        guard let db = db else { return 0 }

        let encoder = JSONEncoder()
        let tagsAsData = try encoder.encode(item.tags)

        let insert = table.insert(
            or: .replace,
            id <- item.id,
            latitude <- item.coordinate.latitude,
            longitude <- item.coordinate.longitude,
            version <- item.version,
            tags <- tagsAsData.datatypeValue
        )
        do {
            return try db.run(insert)
        } catch {
            assertionFailure("Failed to insert: \(error.localizedDescription)")
            return -1
        }
    }

    static func delete(item: T) throws {
        guard let db = db else { return }

        let query = table.filter(id == item.id)
        do {
            let tmp = try db.run(query.delete())
            guard tmp == 1 else {
                assertionFailure("Failed to delete")
                return
            }
        } catch _ {
            assertionFailure("Failed to delete")
        }
    }

    static func find(itemId: Int) throws -> T? {
        guard let db = db else { return nil }

        let query = table.filter(id == itemId)
        do {
            let rows = try db.prepare(query)

            for row in rows {
                return item(from: row)
            }
        }

        return nil
    }

    static func item(from row: Row) -> T? {
        let coordinate = Coordinate(latitude: row[latitude], longitude: row[longitude])

        let tagsAsData = Data.fromDatatypeValue(row[tags])
        let jsonDecoder = JSONDecoder()

        guard let tags = try? jsonDecoder.decode([String: String].self, from: tagsAsData) else {
            assertionFailure("Unable to decode the node's tags.")
            return nil
        }

        return Node(id: row[id],
                    coordinate: coordinate,
                    version: row[version],
                    tags: tags)
    }
}

extension NodeDataHelper: NodeDataManaging {
    func insert(_ node: Node) {
        do {
            _ = try NodeDataHelper.insert(item: node)
        } catch {
            assertionFailure("Failed to insert element: \(error.localizedDescription)")
        }
    }
}
