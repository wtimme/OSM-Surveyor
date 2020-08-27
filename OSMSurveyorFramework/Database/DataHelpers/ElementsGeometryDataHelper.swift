//
//  ElementsGeometryDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

protocol ElementGeometryDataManaging {
    /// Inserts the given `ElementGeometry`.
    /// - Parameter element: The element to insert.
    func insert(_ element: ElementGeometry)
}

class ElementsGeometryDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "elements_geometry"

    static let table = Table(TABLE_NAME)

    static var db: Connection?

    /// Columns
    static let element_type = Expression<String>("element_type")
    static let element_id = Expression<Int>("element_id")
    static let geometry_polylines = Expression<SQLite.Blob?>("geometry_polylines")
    static let geometry_polygons = Expression<SQLite.Blob?>("geometry_polygons")
    static let latitude = Expression<Double>("latitude")
    static let longitude = Expression<Double>("longitude")

    typealias T = ElementGeometry

    static func createTable() throws {
        guard let db = db else { return }

        do {
            _ = try db.run(table.create(ifNotExists: true) { t in
                t.column(element_type)
                t.column(element_id)
                t.column(geometry_polylines)
                t.column(geometry_polygons)
                t.column(latitude)
                t.column(longitude)

                t.primaryKey(element_type, element_id)
            })
        } catch {
            assertionFailure("Failed to create table: \(error.localizedDescription)")
        }
    }

    static func insert(item: T) throws -> Int64 {
        guard let db = db else { return 0 }

        let encoder = JSONEncoder()

        let polylinesAsData: Data?
        if let polylines = item.polylines {
            polylinesAsData = try encoder.encode(polylines)
        } else {
            polylinesAsData = nil
        }

        let polygonsAsData: Data?
        if let polygons = item.polygons {
            polygonsAsData = try encoder.encode(polygons)
        } else {
            polygonsAsData = nil
        }

        let insert = table.insert(
            or: .replace,
            element_type <- item.type.rawValue,
            element_id <- item.elementId,
            geometry_polylines <- polylinesAsData?.datatypeValue,
            geometry_polygons <- polygonsAsData?.datatypeValue,
            latitude <- item.center.latitude,
            longitude <- item.center.longitude
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

        let query = table
            .filter(element_type == item.type.rawValue)
            .filter(element_id == item.elementId)
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

    static func find(elementType: ElementGeometry.ElementType, elementId: Int) throws -> T? {
        guard let db = db else { return nil }

        let query = table
            .filter(element_type == elementType.rawValue)
            .filter(element_id == elementId)
        do {
            let rows = try db.prepare(query)

            for row in rows {
                return item(from: row)
            }
        }

        return nil
    }

    static func item(from row: Row) -> T? {
        guard let elementType = ElementGeometry.ElementType(rawValue: row[element_type]) else { return nil }

        let jsonDecoder = JSONDecoder()

        let polylines: [T.Polyline]?
        if let blob = row[geometry_polylines] {
            let data = Data.fromDatatypeValue(blob)
            polylines = try? jsonDecoder.decode([T.Polyline].self, from: data)
        } else {
            polylines = nil
        }

        let polygons: [T.Polygon]?
        if let blob = row[geometry_polygons] {
            let data = Data.fromDatatypeValue(blob)
            polygons = try? jsonDecoder.decode([T.Polygon].self, from: data)
        } else {
            polygons = nil
        }

        let center = Coordinate(latitude: row[latitude], longitude: row[longitude])

        return ElementGeometry(type: elementType,
                               elementId: row[element_id],
                               polylines: polylines,
                               polygons: polygons,
                               center: center)
    }
}

extension ElementsGeometryDataHelper: ElementGeometryDataManaging {
    func insert(_ element: ElementGeometry) {
        do {
            _ = try ElementsGeometryDataHelper.insert(item: element)
        } catch {
            assertionFailure("Failed to insert element: \(error.localizedDescription)")
        }
    }
}
