//
//  QuestInteractionDelegate.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

/// An object that presents the quest interface.
public protocol QuestInteractionDelegate: class {
    func presentBooleanQuestInterface(question: String,
                                      completion: @escaping (Bool) -> Void)
}
