//
//  QuestProvider.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 03.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol QuestProviding {
    var quests: [QuestTypeProtocol] { get }
}

class QuestProvider {
    /// MARK: Public properties
    
    let quests: [QuestTypeProtocol]
    
    // MARK: Initializer
    
    init(quests: [QuestTypeProtocol] = []) {
        self.quests = quests
    }
}

extension QuestProvider: QuestProviding {}
