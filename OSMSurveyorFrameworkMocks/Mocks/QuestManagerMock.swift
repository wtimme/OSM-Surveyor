//
//  QuestManagerMock.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 28.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class QuestManagerMock {
    private(set) var didCallUpdateQuests = false
    private(set) var updateQuestsArguments: (boundingBox: BoundingBox, ignoreDownloadedQuestsBeforeDate: Date)?
}

extension QuestManagerMock: QuestManaging {
    func updateQuests(in boundingBox: BoundingBox, ignoreDownloadedQuestsBefore date: Date) {
        didCallUpdateQuests = true

        updateQuestsArguments = (boundingBox, date)
    }
}
