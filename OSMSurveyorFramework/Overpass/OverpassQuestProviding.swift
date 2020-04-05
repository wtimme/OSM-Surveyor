//
//  OverpassQuestProviding.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol OverpassQuestProviding {
    /// The quests that are available.
    var quests: [OverpassQuest] { get }
}
