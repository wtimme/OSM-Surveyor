//
//  QuestInteractionCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFrameworkMocks

class QuestInteractionCoordinatorTestCase: XCTestCase {
    
    private var coordinator: QuestInteractionCoordinatorProtocol!
    private var questInteractionProviderMock: QuestInteractionProviderMock!

    override func setUpWithError() throws {
        questInteractionProviderMock = QuestInteractionProviderMock()
        
        coordinator = QuestInteractionCoordinator(questInteractionProvider: questInteractionProviderMock,
                                                  navigationController: UINavigationController())
    }

    override func tearDownWithError() throws {
        coordinator = nil
        questInteractionProviderMock = nil
    }

}
