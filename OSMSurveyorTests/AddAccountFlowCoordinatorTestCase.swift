//
//  AddAccountFlowCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks

class AddAccountFlowCoordinatorTestCase: XCTestCase {
    
    var coordinator: AddAccountFlowCoordinatorProtocol!
    var navigationController: UINavigationController!
    var oAuthHandlerMock: OAuthHandlerMock!
    var apiClientMock: OpenStreetMapAPIClientMock!
    var keychainHandlerMock: KeychainHandlerMock!

    override func setUpWithError() throws {
        oAuthHandlerMock = OAuthHandlerMock()
        navigationController = UINavigationController()
        apiClientMock = OpenStreetMapAPIClientMock()
        keychainHandlerMock = KeychainHandlerMock()
        
        coordinator = AddAccountFlowCoordinator(navigationController: navigationController,
                                                oAuthHandler: oAuthHandlerMock,
                                                apiClient: apiClientMock,
                                                keychainHandler: keychainHandlerMock)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        navigationController = nil
        oAuthHandlerMock = nil
        apiClientMock = nil
        keychainHandlerMock = nil
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
    
    func testStart_whenOAuthHandlerAuthorizedSuccessful_shouldAskOpenStreetMapAPIClientToFetchUserDetails() {
        /// Given
        let token = "foo"
        let tokenSecret = "bar"
        
        coordinator.start()
        
        /// When
        oAuthHandlerMock.authorizeCompletion?(.success((token, tokenSecret)))
        
        XCTAssertTrue(apiClientMock.didCallUserDetails)
        XCTAssertEqual(apiClientMock.userDetailsArguments?.token, token)
        XCTAssertEqual(apiClientMock.userDetailsArguments?.tokenSecret, tokenSecret)
    }
    
    func testStart_whenAPIClientFailedToFetchUserDetails_shouldExecuteOnFinishWithError() {
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
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.userDetailsArguments?.completion(.failure(error))
        
        /// Then
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(coordinatorError as? NSError, error)
    }
    
    func testStart_whenOAuthHandlerAuthorizedAndTheUserDetailsWereFetchedSuccessful_shouldAskOpenStreetMapAPIClientToGetPermissions() {
        /// Given
        let token = "foo"
        let tokenSecret = "bar"
        
        coordinator.start()
        
        /// When
        oAuthHandlerMock.authorizeCompletion?(.success((token, tokenSecret)))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: "")))
        
        XCTAssertTrue(apiClientMock.didCallPermissions)
        XCTAssertEqual(apiClientMock.permissionsArguments?.token, token)
        XCTAssertEqual(apiClientMock.permissionsArguments?.tokenSecret, tokenSecret)
    }
    
    func testStart_whenPermissionsAreInsufficient_shouldExecuteOnFinishWithError() {
        /// Given
        let permissions: [Permission] = [.allow_read_gpx, .allow_write_notes]
        
        let onFinishExpectation = expectation(description: "Coordinator should finish")
        var coordinatorError: Error?
        coordinator.onFinish = { result in
            if case let .failure(resultingError) = result {
                coordinatorError = resultingError
            }
            
            onFinishExpectation.fulfill()
        }
        
        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: "")))
        apiClientMock.permissionsArguments?.completion(.success(permissions))
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertTrue(AddAccountFlowCoordinatorError.insufficientPermissions == (coordinatorError as? AddAccountFlowCoordinatorError))
    }
    
    func testStart_whenOAuthHandlerAuthorizedAndTheUserDetailsWereFetchedAndAllRequiredPermissionsArePresent_shouldAskKeychainHandlerToAddEntry() {
        /// Given
        let username = "jane.doe"
        let token = "lorem"
        let tokenSecret = "ipsum"
        
        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success((token, tokenSecret)))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: username)))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        
        // Then
        XCTAssertTrue(keychainHandlerMock.didCallAdd)
        XCTAssertEqual(keychainHandlerMock.addArguments?.username, username)
        XCTAssertEqual(keychainHandlerMock.addArguments?.credentials.token, token)
        XCTAssertEqual(keychainHandlerMock.addArguments?.credentials.tokenSecret, tokenSecret)
    }
    
    func testStart_whenKeychainThrewAnError_shouldExecuteOnFinishWithError() {
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
        
        keychainHandlerMock.addError = error
        
        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: "")))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(coordinatorError as? NSError, error)
    }
    
    func testStart_whenKeychainDidNotThrowAnError_shouldExecuteOnFinishWithSuccessAndUsername() {
        /// Given
        let username = "jane.doe"
        
        let onFinishExpectation = expectation(description: "Coordinator should finish")
        var coordinatorUsername: String?
        coordinator.onFinish = { result in
            if case let .success(username) = result {
                coordinatorUsername = username
            }
            
            onFinishExpectation.fulfill()
        }
        
        keychainHandlerMock.addError = nil
        
        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: username)))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(coordinatorUsername, username)
    }

}
