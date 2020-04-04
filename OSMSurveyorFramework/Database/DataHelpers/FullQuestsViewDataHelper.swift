//
//  FullQuestsViewDataHelper.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

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
}
