//
//  CoordinateTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

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

}
