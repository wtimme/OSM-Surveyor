//
//  CoordinateTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework
import XCTest

class CoordinateTestCase: XCTestCase {
    func testEquals_whenTheCoordinatesAreTheSame_shouldReturnTrue() {
        let firstCoordinate = Coordinate(latitude: 0.0000000, longitude: 0.0000000)
        let secondCoordinate = Coordinate(latitude: 0.0000000, longitude: 0.0000000)

        XCTAssertEqual(firstCoordinate, secondCoordinate)
    }

    func testEquals_whenTheCoordinatesAreDifferent_shouldReturnFalse() {
        let firstCoordinate = Coordinate(latitude: 0.0000000, longitude: 0.0000000)
        let secondCoordinate = Coordinate(latitude: 0.0000001, longitude: 0.0000000)

        XCTAssertNotEqual(firstCoordinate, secondCoordinate)
    }

    // MARK: Distance calculation

    private let hamburgCoordinate = Coordinate(latitude: 53.5, longitude: 10.0)

    func testDistanceBetweenHamburgAndBerlin() {
        checkHamburgTo(52.4, 13.4, 259, 117, 120)
    }

    func testDistanceBetweenHamburgAndLuebeck() {
        checkHamburgTo(53.85, 10.68, 59, 49, 49)
    }

    func testDistanceBetweenHamburgAndLosAngeles() {
        checkHamburgTo(34.0, -118.0, 9075, 319, 208)
    }

    func testDistanceBetweenHamburgAndReykjavik() {
        checkHamburgTo(64.11, -21.98, 2152, 316, 288)
    }

    func testDistanceBetweenHamburgAndPortElizabeth() {
        checkHamburgTo(-33.9, -25.6, 10307, 209, 200)
    }

    func testDistanceBetweenHamburgAndThePoles() {
        checkHamburgTo(90.0, 123.0, 4059, 0, nil)
        checkHamburgTo(-90.0, 0.0, 15956, 180, nil)
    }

    func testDistanceBetweenHamburgAndTheOtherSideOfTheEarth() {
        checkHamburgTo(-53.5, -170.0, Int(Double.pi * 6371), 270, 270)
    }

    private func checkHamburgTo(_ latitude: Double, _ longitude: Double, _ expectedDistance: Int, _: Int, _: Int?) {
        let otherCoordinate = Coordinate(latitude: latitude, longitude: longitude)
        XCTAssertEqual(Int((hamburgCoordinate.distance(to: otherCoordinate) / 1000).rounded()), expectedDistance)
        XCTAssertEqual(Int((otherCoordinate.distance(to: hamburgCoordinate) / 1000).rounded()), expectedDistance)
    }
}
