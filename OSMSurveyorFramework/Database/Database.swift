//
//  Database.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SQLite

public class Database {
    // MARK: Private properties

    private let connection: Connection

    // MARK: Initializer

    public init?(filename: String = "db.sqlite3") {
        guard let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first else {
            return nil
        }

        do {
            connection = try Connection("\(documentsDirectoryPath)/\(filename)")
        } catch {
            assertionFailure("Unable to open the database: \(error.localizedDescription)")

            return nil
        }

        NodeDataHelper.db = connection
        try? NodeDataHelper.createTable()

        QuestDataHelper.db = connection
        try? QuestDataHelper.createTable()

        DownloadedTileDataHelper.db = connection
        try? DownloadedTileDataHelper.createTable()

        ElementsGeometryDataHelper.db = connection
        try? ElementsGeometryDataHelper.createTable()

        FullQuestsViewHelper.db = connection
        try? FullQuestsViewHelper.createView()
    }
}
