//
//  FullQuestsViewDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

protocol FullQuestsDataProviding {
    func findElementKeysForQuests(ofTypes questTypes: [String], in boundingBox: BoundingBox) -> [ElementKey]

    func findQuests(in boundingBox: BoundingBox) -> [(elementType: String, elementId: Int, coordinate: Coordinate, questType: String)]
}

class FullQuestsViewHelper {
    static let VIEW_NAME = "osm_quests_full"

    static let view = View(VIEW_NAME)

    static var db: Connection?

    static func createView() throws {
        guard let db = db else { return }

        do {
            let viewQuery = QuestDataHelper.table.join(ElementsGeometryDataHelper.table,
                                                       on: ElementsGeometryDataHelper.table[ElementsGeometryDataHelper.element_type] == QuestDataHelper.table[QuestDataHelper.element_type] && ElementsGeometryDataHelper.table[ElementsGeometryDataHelper.element_id] == QuestDataHelper.table[QuestDataHelper.element_id])
            _ = try db.run(view.create(viewQuery, temporary: false, ifNotExists: true))
        } catch {
            assertionFailure("Failed to create view: \(error.localizedDescription)")
        }
    }

    private static func findRows(ofTypes questTypes: [String] = [], in boundingBox: BoundingBox) -> AnySequence<Row>? {
        guard let db = db else { return nil }

        var query = view
        if !questTypes.isEmpty {
            query = query.filter(questTypes.contains(QuestDataHelper.quest_type))
        }

        query = query.filter(boundingBox.minimum.latitude ... boundingBox.maximum.latitude ~= ElementsGeometryDataHelper.latitude)
        query = query.filter(boundingBox.minimum.longitude ... boundingBox.maximum.longitude ~= ElementsGeometryDataHelper.longitude)

        do {
            let rows = try db.prepare(query)

            return rows
        } catch {
            assertionFailure("Failed to find element keys")
        }

        return nil
    }

    static func findElementKeysForQuests(ofTypes questTypes: [String], in boundingBox: BoundingBox) -> [ElementKey] {
        guard let rows = findRows(ofTypes: questTypes, in: boundingBox) else { return [] }

        return rows.compactMap { row in
            guard
                let elementTypeAsString = try? row.get(QuestDataHelper.element_type),
                let elementType = ElementGeometry.ElementType(rawValue: elementTypeAsString),
                let elementId = try? row.get(QuestDataHelper.element_id)
            else {
                return nil
            }

            return ElementKey(elementType: elementType, elementId: elementId)
        }
    }

    static func findQuests(in boundingBox: BoundingBox) -> [(elementType: String, elementId: Int, coordinate: Coordinate, questType: String)] {
        guard let rows = findRows(in: boundingBox) else { return [] }

        return rows.compactMap { row in
            guard
                let elementId = try? row.get(ElementsGeometryDataHelper.element_id),
                let elementType = try? row.get(ElementsGeometryDataHelper.element_type),
                let questType = try? row.get(QuestDataHelper.quest_type),
                let latitude = try? row.get(ElementsGeometryDataHelper.latitude),
                let longitude = try? row.get(ElementsGeometryDataHelper.longitude)
            else {
                return nil
            }

            return (elementType, elementId, Coordinate(latitude: latitude, longitude: longitude), questType)
        }
    }
}

extension FullQuestsViewHelper: FullQuestsDataProviding {
    func findElementKeysForQuests(ofTypes questTypes: [String], in boundingBox: BoundingBox) -> [ElementKey] {
        return FullQuestsViewHelper.findElementKeysForQuests(ofTypes: questTypes, in: boundingBox)
    }

    func findQuests(in boundingBox: BoundingBox) -> [(elementType: String, elementId: Int, coordinate: Coordinate, questType: String)] {
        return FullQuestsViewHelper.findQuests(in: boundingBox)
    }
}
