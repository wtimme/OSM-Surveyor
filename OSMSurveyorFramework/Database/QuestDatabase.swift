//
//  QuestDatabase.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

public class QuestDatabase {
    // MARK: Private properties
    
    private let connection: Connection
    
    // MARK: Initializer
    
    public init?(name: String, type: String = "sqlite3", bundle: Bundle = .main) {
        guard let databaseURL = Bundle.main.path(forResource: name, ofType: type) else {
            print("Unable to find path to database.")
            return nil
        }
        
        do {
            let location = Connection.Location.uri(databaseURL)
            connection = try Connection(location, readonly: false)
        } catch {
            assertionFailure("Unable to open the database: \(error.localizedDescription)")
            
            return nil
        }
    }
}
