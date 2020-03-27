//
//  NodeDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

class NodeDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "osm_nodes"
   
    static let table = Table(TABLE_NAME)
    
    static var db: Connection?
    
    /// Columns
    static let id = Expression<Int64>("id")
    static let latitude = Expression<Double>("latitude")
    static let longitude = Expression<Double>("longitude")
    static let version = Expression<Int64>("version")
    static let tags = Expression<SQLite.Blob>("tags")
   
    typealias T = Node
   
    static func createTable() throws {
        guard let db = db else { return }
        
        do {
            let _ = try db.run(table.create(ifNotExists: true) { t in
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
            latitude <- item.latitude,
            longitude <- item.longitude,
            version <- item.version,
            tags <- tagsAsData.datatypeValue)
        do {
            return try db.run(insert)
        } catch {
            assertionFailure("Failed to insert: \(error.localizedDescription)")
            return -1
        }
    }
   
    static func delete (item: T) throws -> Void {
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
   
    static func find(itemId: Int64) throws -> T? {
        guard let db = db else { return nil }
        
        let query = table.filter(id == itemId)
        do {
            let items = try db.prepare(query)
            
            for item in items {
                let tagsAsData = Data.fromDatatypeValue(item[tags])
                let jsonDecoder = JSONDecoder()
                let tags = try jsonDecoder.decode([String: String].self, from: tagsAsData)
                
                return Node(id: item[id],
                            latitude: item[latitude],
                            longitude: item[longitude],
                            version: item[version],
                            tags: tags)
            }
        }
       
        return nil
       
    }
   
    static func findAll() throws -> [T]? {
        guard let db = db else { return [] }
        
        do {
            let rows = try db.prepare(table)
            
            return try rows.map { item -> Node in
                let tagsAsData = Data.fromDatatypeValue(item[tags])
                let jsonDecoder = JSONDecoder()
                let tags = try jsonDecoder.decode([String: String].self, from: tagsAsData)
                
                return Node(id: item[id],
                            latitude: item[latitude],
                            longitude: item[longitude],
                            version: item[version],
                            tags: tags)
            }
        } catch {
            assertionFailure("Failed to find all: \(error.localizedDescription)")
            return nil
        }
    }
}
