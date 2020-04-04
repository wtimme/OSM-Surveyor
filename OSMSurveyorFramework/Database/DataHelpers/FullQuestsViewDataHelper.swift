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
}

class FullQuestsViewHelper {
    static let VIEW_NAME = "osm_quests_full"
   
    static let view = View(VIEW_NAME)
    
    static var db: Connection?
   
    static func createView() throws {
        guard let db = db else { return }
        
        do {
            let viewQuery = QuestDataHelper.table.join(ElementsGeometryDataHelper.table,
                                                       on: (ElementsGeometryDataHelper.table[ElementsGeometryDataHelper.element_type] == QuestDataHelper.table[QuestDataHelper.element_type] && ElementsGeometryDataHelper.table[ElementsGeometryDataHelper.element_id] == QuestDataHelper.table[QuestDataHelper.element_id]))
            let _ = try db.run(view.create(viewQuery, temporary: false, ifNotExists: true))
        } catch {
            assertionFailure("Failed to create view: \(error.localizedDescription)")
        }
       
    }
    
    static func findElementKeysForQuests(ofTypes questTypes: [String], in boundingBox: BoundingBox) -> [ElementKey] {
        guard let db = db else { return [] }
        
        var query = view
        if !questTypes.isEmpty {
            query = query.filter(questTypes.contains(QuestDataHelper.quest_type))
        }
        
        query = query.filter(boundingBox.minimum.latitude...boundingBox.maximum.latitude ~= ElementsGeometryDataHelper.latitude)
        query = query.filter(boundingBox.minimum.longitude...boundingBox.maximum.longitude ~= ElementsGeometryDataHelper.longitude)

        do {
            let rows = try db.prepare(query)
            
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
        } catch {
            assertionFailure("Failed to find element keys")
        }
        
        return []
    }
}

extension FullQuestsViewHelper: FullQuestsDataProviding {
    func findElementKeysForQuests(ofTypes questTypes: [String], in boundingBox: BoundingBox) -> [ElementKey] {
        return FullQuestsViewHelper.findElementKeysForQuests(ofTypes: questTypes, in: boundingBox)
    }
}
