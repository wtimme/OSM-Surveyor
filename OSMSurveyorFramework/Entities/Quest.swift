//
//  Quest.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// A `Quest` represents one single task that the mapper can solve.
struct Quest {
    enum Status: String {
        /// just created
        case new = "NEW"

        /// user answered the question (waiting for changes to be uploaded)
        case answered = "ANSWERED"

        /// user chose to hide the quest
        case hidden = "HIDDEN"

        /// The system (decided that it) doesn't show the quest. They may become visible again (-> NEW)
        case invisible = "INVISIBLE"

        /**
         The quest has been uploaded (either solved or dropped through conflict). The app needs to
         remember its solved quests for some time before deleting them because the source the app
         is pulling it's data for creating quests from (usually Overpass) lags behind the database
         where the app is uploading its changes to.
         Note quests are generally closed after upload, they are never deleted
         */
        case closed = "CLOSED"

        /**
         The quest has been closed and after that the user chose to revert (aka undo) it. This state
         is basically the same as CLOSED, only that it will not turn up in the list of (revertable)
         changes. Note, that the revert-change is done via another Quest upload, this state is only
         to mark this quest as that a revert-quest has already been created
         */
        case revert = "REVERT"
    }

    /// An auto-incremented ID to identify the quest.
    let id: Int64

    /// The quest type. One quest type can have multiple instances of `Quest`.
    let type: String

    /// The status of the quest.
    let status: Status

    /// The date at which the quest was last updated.
    /// Can be used, for example, to get a list of recently solved quests.
    let lastUpdate: Date

    /// The type of the OSM element that this quest refers to.
    let elementType: ElementGeometry.ElementType

    /// The ID of the OSM element that this quest refers to.
    let elementId: Int
}
