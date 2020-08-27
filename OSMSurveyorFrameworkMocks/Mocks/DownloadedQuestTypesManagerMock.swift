//
//  DownloadedQuestTypesManagerMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 05.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class DownloadedQuestTypesManagerMock {
    private(set) var didCallFindDownloadedQuestTypes = false
    private(set) var findDownloadedQuestTypesArguments: (tilesRect: TilesRect, date: Date)?
    var findDownloadedQuestTypesReturnValue = [String]()

    private(set) var didCallMarkQuestTypeAsDownloaded = false
    private(set) var markQuestTypeAsDownloadedArguments: (tilesRect: TilesRect, questType: String)?
}

extension DownloadedQuestTypesManagerMock: DownloadedQuestTypesManaging {
    func findDownloadedQuestTypes(in tilesRect: TilesRect, ignoreOlderThan date: Date) -> [String] {
        didCallFindDownloadedQuestTypes = true

        findDownloadedQuestTypesArguments = (tilesRect, date)

        return findDownloadedQuestTypesReturnValue
    }

    func markQuestTypeAsDownloaded(tilesRect: TilesRect, questType: String) {
        didCallMarkQuestTypeAsDownloaded = true

        markQuestTypeAsDownloadedArguments = (tilesRect, questType)
    }
}
