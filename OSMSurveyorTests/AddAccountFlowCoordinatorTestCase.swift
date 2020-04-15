//
//  AddAccountFlowCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyor
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks
import XCTest

class AddAccountFlowCoordinatorTestCase: XCTestCase {
    var coordinator: AddAccountFlowCoordinatorProtocol!
    var presentingViewController: UIViewController!
    var alertPresenterMock: AlertPresenterMock!
    var oAuthHandlerMock: OAuthHandlerMock!
    var apiClientMock: OpenStreetMapAPIClientMock!
    var keychainHandlerMock: KeychainHandlerMock!

    override func setUpWithError() throws {
        oAuthHandlerMock = OAuthHandlerMock()
        presentingViewController = UIViewController()
        alertPresenterMock = AlertPresenterMock()
        apiClientMock = OpenStreetMapAPIClientMock()
        keychainHandlerMock = KeychainHandlerMock()

        coordinator = AddAccountFlowCoordinator(presentingViewController: presentingViewController,
                                                alertPresenter: alertPresenterMock,
                                                oAuthHandler: oAuthHandlerMock,
                                                apiClient: apiClientMock,
                                                keychainHandler: keychainHandlerMock)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        presentingViewController = nil
        alertPresenterMock = nil
        oAuthHandlerMock = nil
        apiClientMock = nil
        keychainHandlerMock = nil
    }

    func testStart_shouldAskOAuthHandlerToAuthorize() {
        /// When
        coordinator.start()

        /// Then
        XCTAssertTrue(oAuthHandlerMock.didCallAuthorize)
        XCTAssertEqual(oAuthHandlerMock.authorizeFromViewController as? UIViewController, presentingViewController)
    }

    func testStart_whenOAuthHandlerEncountersAnError_shouldAskAlertPresenterToPresentAlert() {
        /// Given
        let localizedErrorDescription = "Lorem ipsum"
        let error = NSError(domain: "com.example.error", code: 1, userInfo: [NSLocalizedDescriptionKey: localizedErrorDescription])

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.failure(error))

        /// Then
        XCTAssertTrue(alertPresenterMock.didCallPresentAlert)
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.title, "Error")
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.message, localizedErrorDescription)
    }

    func testStart_whenOAuthHandlerAuthorizedSuccessful_shouldAskOpenStreetMapAPIClientToFetchPermissions() {
        /// Given
        let token = "foo"
        let tokenSecret = "bar"

        coordinator.start()

        /// When
        oAuthHandlerMock.authorizeCompletion?(.success((token, tokenSecret)))

        XCTAssertTrue(apiClientMock.didCallPermissions)
        XCTAssertEqual(apiClientMock.permissionsArguments?.token, token)
        XCTAssertEqual(apiClientMock.permissionsArguments?.tokenSecret, tokenSecret)
    }

    func testStart_whenAPIClientFailedToFetchPermissions_shouldAskAlertPresenterToPresentAlert() {
        /// Given
        let localizedErrorDescription = "Lorem ipsum"
        let error = NSError(domain: "com.example.error", code: 1, userInfo: [NSLocalizedDescriptionKey: localizedErrorDescription])

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.permissionsArguments?.completion(.failure(error))

        /// Then
        XCTAssertTrue(alertPresenterMock.didCallPresentAlert)
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.title, "Error")
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.message, localizedErrorDescription)
    }

    func testStart_whenPermissionsAreInsufficient_shouldAskAlertPresenterToPresentAlert() {
        /// Given
        let permissions: [Permission] = [.allow_read_gpx, .allow_write_notes]

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.permissionsArguments?.completion(.success(permissions))

        // Then
        XCTAssertTrue(alertPresenterMock.didCallPresentAlert)
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.title,
                       "Insufficient privileges")
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.message,
                       "Please allow the app to access ALL OAuth permissions. Do not uncheck the checkboxes! Otherwise, the app will not work properly.")
    }

    func testStart_whenOAuthHandlerAuthorizedAndThePermissionsAreSufficient_shouldAskOpenStreetMapAPIClientToFetchUserDetails() {
        /// Given
        let token = "foo"
        let tokenSecret = "bar"

        coordinator.start()

        /// When
        oAuthHandlerMock.authorizeCompletion?(.success((token, tokenSecret)))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))

        XCTAssertTrue(apiClientMock.didCallUserDetails)
        XCTAssertEqual(apiClientMock.userDetailsArguments?.token, token)
        XCTAssertEqual(apiClientMock.userDetailsArguments?.tokenSecret, tokenSecret)
    }

    func testStart_whenAPIClientFailedToFetchUserDetails_shouldAskAlertPresenterToPresentAlert() {
        /// Given
        let localizedErrorDescription = "Lorem ipsum"
        let error = NSError(domain: "com.example.error", code: 1, userInfo: [NSLocalizedDescriptionKey: localizedErrorDescription])

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        apiClientMock.userDetailsArguments?.completion(.failure(error))

        /// Then
        XCTAssertTrue(alertPresenterMock.didCallPresentAlert)
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.title, "Error")
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.message, localizedErrorDescription)
    }

    func testStart_whenOAuthHandlerAuthorizedAndAllRequiredPermissionsArePresentAndTheUserDetailsWereFetched_shouldAskKeychainHandlerToAddEntry() {
        /// Given
        let username = "jane.doe"
        let token = "lorem"
        let tokenSecret = "ipsum"

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success((token, tokenSecret)))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: username)))

        // Then
        XCTAssertTrue(keychainHandlerMock.didCallAdd)
        XCTAssertEqual(keychainHandlerMock.addArguments?.username, username)
        XCTAssertEqual(keychainHandlerMock.addArguments?.credentials.token, token)
        XCTAssertEqual(keychainHandlerMock.addArguments?.credentials.tokenSecret, tokenSecret)
    }

    func testStart_whenKeychainThrewAnError_shouldAskAlertPresenterToPresentAlert() {
        /// Given
        keychainHandlerMock.addError = KeychainError.usernameAlreadyExists

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: "")))

        // Then
        XCTAssertTrue(alertPresenterMock.didCallPresentAlert)
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.title,
                       "Account already added")
        XCTAssertEqual(alertPresenterMock.presentAlertArguments?.message,
                       "An account can only be added once. Please remove the existing one before adding it again.")
    }

    func testStart_whenKeychainDidNotThrowAnError_shouldExecuteOnFinish() {
        /// Given
        let onFinishExpectation = expectation(description: "Coordinator should finish")
        coordinator.onFinish = {
            onFinishExpectation.fulfill()
        }

        keychainHandlerMock.addError = nil

        /// When
        coordinator.start()
        oAuthHandlerMock.authorizeCompletion?(.success(("", "")))
        apiClientMock.permissionsArguments?.completion(.success([.allow_write_api, .allow_read_prefs]))
        apiClientMock.userDetailsArguments?.completion(.success(UserDetails(username: "")))

        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
}
