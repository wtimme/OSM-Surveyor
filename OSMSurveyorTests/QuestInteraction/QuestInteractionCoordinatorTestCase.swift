//
//  QuestInteractionCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor

class QuestInteractionCoordinatorTestCase: XCTestCase {
    
    private var coordinator: QuestInteractionCoordinatorProtocol!

    override func setUpWithError() throws {
        coordinator = QuestInteractionCoordinator(navigationController: UINavigationController())
    }

    override func tearDownWithError() throws {
        coordinator = nil
    }

}
