//
//  UploadFlowCoordinatorMock.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyor

final class UploadFlowCoordinatorMock {
    private(set) var didCallStart = false
    private(set) var startArguments: (questType: String, questId: Int)?
}

extension UploadFlowCoordinatorMock: UploadFlowCoordinatorProtocol {
    func start(questType: String, questId: Int) {
        didCallStart = true
        
        startArguments = (questType, questId)
    }
}
