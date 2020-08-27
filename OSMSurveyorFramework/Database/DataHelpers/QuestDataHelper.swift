//
//  QuestDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

protocol QuestDataManaging {
    /// Inserts a new `Quest`.
    /// - Parameters:
    ///   - questType: The type of the `Quest`.
    ///   - elementId: The ID of the related element.
    ///   - geometry: The `ElementGeometry` of the quest.
    func insert(questType: String,
                elementId: Int,
                geometry: ElementGeometry)
}

class QuestDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "osm_quests"

    static let table = Table(TABLE_NAME)

    static var db: Connection?

    /// Columns
    static let quest_id = Expression<Int64>("quest_id")
    static let quest_type = Expression<String>("quest_type")
    static let quest_status = Expression<String>("quest_status")
    static let last_update = Expression<Int>("last_update")
    static let element_id = Expression<Int>("element_id")
    static let element_type = Expression<String>("element_type")

    typealias T = Quest

    static func createTable() throws {
        guard let db = db else { return }

        do {
            _ = try db.run(table.create(ifNotExists: true) { t in
                t.column(quest_id, primaryKey: .autoincrement)
                t.column(quest_type)
                t.column(quest_status)
                t.column(last_update)
                t.column(element_id)
                t.column(element_type)
            })
        } catch {
            assertionFailure("Failed to create table: \(error.localizedDescription)")
        }
    }

    static func insert(item: T) throws -> Int64 {
        guard let db = db else { return 0 }

        let insert = table.insert(
            quest_type <- item.type,
            quest_status <- item.status.rawValue,
            last_update <- Int(item.lastUpdate.timeIntervalSince1970),
            element_id <- item.elementId,
            element_type <- item.elementType.rawValue
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

        let query = table.filter(quest_id == item.id)
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

        let query = table.filter(quest_id == itemId)
        do {
            let rows = try db.prepare(query)

            for row in rows {
                return item(from: row)
            }
        }

        return nil
    }

    static func item(from row: Row) -> T? {
        guard let questStatus = Quest.Status(rawValue: row[quest_status]) else {
            assertionFailure("Unable to determine the quest's status.")
            return nil
        }

        let lastUpdateDate = Date(timeIntervalSince1970: TimeInterval(row[last_update]))

        guard let elementType = ElementGeometry.ElementType(rawValue: row[element_type]) else {
            assertionFailure("Unable to determine the quest's element type.")
            return nil
        }

        return Quest(id: row[quest_id],
                     type: row[quest_type],
                     status: questStatus,
                     lastUpdate: lastUpdateDate,
                     elementType: elementType,
                     elementId: row[element_id])
    }

    private static func insert(questType: String, elementId: Int, geometry: ElementGeometry) throws {
        let quest = Quest(id: 0,
                          type: questType,
                          status: .new,
                          lastUpdate: Date(),
                          elementType: geometry.type,
                          elementId: elementId)

        try _ = insert(item: quest)
    }
}

extension QuestDataHelper: QuestDataManaging {
    func insert(questType: String, elementId: Int, geometry: ElementGeometry) {
        do {
            try QuestDataHelper.insert(questType: questType,
                                       elementId: elementId,
                                       geometry: geometry)
        } catch {
            assertionFailure("Failed to insert Quest: \(error.localizedDescription)")
        }
    }
}
