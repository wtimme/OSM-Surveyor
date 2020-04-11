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
    
    func testStart_shouldAskOAuthHandlerToAuthorize() {
        /// When
        coordinator.start()
        
        /// Then
        XCTAssertTrue(oAuthHandlerMock.didCallAuthorize)
        XCTAssertEqual(oAuthHandlerMock.authorizeFromViewController as? UIViewController, navigationController)
    }
    
    func testStart_whenOAuthHandlerEncountersAnError_shouldExecuteOnFinishWithError() {
        /// Given
        let error = NSError(domain: "com.example.error", code: 1, userInfo: nil)
        
        let onFinishExpectation = expectation(description: "Coordinator should finish")
        var coordinatorError: Error?
        coordinator.onFinish = { result in
            if case let .failure(resultingError) = result {
                coordinatorError = resultingError
            }
            
            onFinishExpectation.fulfill()
        }
        
        coordinator.start()
        
        /// When
        oAuthHandlerMock.authorizeCompletion?(.failure(error))
        
        /// Then
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(coordinatorError as? NSError, error)
    }

}
