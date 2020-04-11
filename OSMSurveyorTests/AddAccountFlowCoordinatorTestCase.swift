//
//  AddAccountFlowCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFrameworkMocks

class AddAccountFlowCoordinatorTestCase: XCTestCase {
    
    var coordinator: AddAccountFlowCoordinatorProtocol!
    var navigationController: UINavigationController!
    var oAuthHandlerMock: OAuthHandlerMock!

    override func setUpWithError() throws {
        oAuthHandlerMock = OAuthHandlerMock()
        navigationController = UINavigationController()
        
        coordinator = AddAccountFlowCoordinator(navigationController: navigationController,
                                                oAuthHandler: oAuthHandlerMock)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        navigationController = nil
        oAuthHandlerMock = nil
    }

}
