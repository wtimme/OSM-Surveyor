//
//  UploadFlowCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor

class UploadFlowCoordinatorTestCase: XCTestCase {
    
    private var coordinator: UploadFlowCoordinatorProtocol!

    override func setUpWithError() throws {
        coordinator = UploadFlowCoordinator()
    }

    override func tearDownWithError() throws {
        coordinator = nil
    }

}
