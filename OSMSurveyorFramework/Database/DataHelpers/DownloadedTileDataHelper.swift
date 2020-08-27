//
//  DownloadedTileDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

protocol DownloadedQuestTypesManaging {
    /// Gets the `Quest` types which have already been downloaded in the given `TilesRect`.
    /// - Parameters:
    ///   - tilesRect: The `TilesRect` for which to find the downloaded quest types.
    ///   - date: The date after after which to consider the information outdated. Records older than this date will not be returned.
    func findDownloadedQuestTypes(in tilesRect: TilesRect, ignoreOlderThan date: Date) -> [String]

    /// Marks the given quest type as downloaded in the given `TilesRect`.
    /// - Parameters:
    ///   - tilesRect: The `TilesRect` in which the quest types were downloaded.
    ///   - questType: The type of quest that was downloaded.
    func markQuestTypeAsDownloaded(tilesRect: TilesRect, questType: String)
}

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
            _ = try db.run(table.create(ifNotExists: true) { t in
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
            or: .replace,
            x <- item.tile.x,
            y <- item.tile.y,
            quest_type <- item.questType,
            date <- Int(item.date.timeIntervalSince1970)
        )
        do {
            return try db.run(insert)
        } catch {
            assertionFailure("Failed to insert: \(error.localizedDescription)")
            return -1
        }
    }

    static func insertOrUpdate(_ items: [T]) throws {
        guard let db = db else { return }

        try db.transaction {
            for item in items {
                _ = try insert(item: item)
            }
        }
    }

    static func delete(item: T) throws {
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

        let query = table.filter(self.x == x && self.y == y && quest_type == questType)
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

    /// Returns a list of quest type names which have already been downloaded in every tile in the given tile range
    static func findDownloadedQuestTypes(in tilesRect: TilesRect, ignoreOlderThan date: Date) -> [String] {
        guard let db = db else { return [] }

        let query = table
            .select(quest_type)
            .filter(tilesRect.left ... tilesRect.right ~= x && tilesRect.top ... tilesRect.bottom ~= y && Int(date.timeIntervalSince1970) < self.date)
            .group(quest_type, having: count(*) >= 1)

        do {
            let rows = try db.prepare(query)

            return rows.map { $0[quest_type] }
        } catch {
            assertionFailure("Failed to execute query: \(error.localizedDescription)")
            return []
        }
    }
}

extension DownloadedTileDataHelper: DownloadedQuestTypesManaging {
    func findDownloadedQuestTypes(in tilesRect: TilesRect, ignoreOlderThan date: Date) -> [String] {
        DownloadedTileDataHelper.findDownloadedQuestTypes(in: tilesRect,
                                                          ignoreOlderThan: date)
    }

    func markQuestTypeAsDownloaded(tilesRect: TilesRect, questType: String) {
        let downloadedTiles = tilesRect.tiles().map { tile in
            DownloadedTile(tile: tile, questType: questType, date: Date())
        }

        try? DownloadedTileDataHelper.insertOrUpdate(downloadedTiles)
    }
}
