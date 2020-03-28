//
//  DownloadedTileDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

class DownloadedTileDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "downloaded_tiles"
   
    static let table = Table(TABLE_NAME)
    
    static var db: Connection?
    
    /// Columns
    static let x = Expression<Int>("x")
    static let y = Expression<Int>("y")
    static let quest_type = Expression<String>("quest_type")
    static let date = Expression<Int>("date")
   
    typealias T = DownloadedTile
   
    static func createTable() throws {
        guard let db = db else { return }
        
        do {
            let _ = try db.run(table.create(ifNotExists: true) { t in
                t.column(x)
                t.column(y)
                t.column(quest_type)
                t.column(date)
                
                t.primaryKey(x, y, quest_type)
            })
        } catch {
            assertionFailure("Failed to create table: \(error.localizedDescription)")
        }
       
    }
   
    static func insert(item: T) throws -> Int64 {
        guard let db = db else { return 0 }
        
        let insert = table.insert(
            x <- item.tile.x,
            y <- item.tile.y,
            quest_type <- item.questType,
            date <- Int(item.date.timeIntervalSince1970))
        do {
            return try db.run(insert)
        } catch {
            assertionFailure("Failed to insert: \(error.localizedDescription)")
            return -1
        }
    }
   
    static func delete (item: T) throws -> Void {
        guard let db = db else { return }
        
        let query = table.filter(x == item.tile.x && y == item.tile.y && quest_type == item.questType)
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
   
    static func find(x: Int, y: Int, questType: String) throws -> T? {
        guard let db = db else { return nil }
        
        let query = table.filter(self.x == x && self.y == y && self.quest_type == questType)
        do {
            let rows = try db.prepare(query)
            
            for row in rows {
                return item(from: row)
            }
        }
       
        return nil
       
    }
    
    static func item(from row: Row) -> T? {
        return DownloadedTile(tile: Tile(x: row[x], y: row[y]),
                              questType: row[quest_type],
                              date: Date(timeIntervalSince1970: TimeInterval(row[date])))
    }
}
