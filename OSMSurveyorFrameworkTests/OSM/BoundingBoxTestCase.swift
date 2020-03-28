//
//  BoundingBoxTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 27.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class BoundingBoxTestCase: XCTestCase {

    func testEquals_whenTheBoundingBoxesAreEqual_shouldReturnTrue() {
        let minimumCoordinate = Coordinate(latitude: 0, longitude: 0)
        let maximumCoordinate = Coordinate(latitude: 1, longitude: 1)
        
        let firstBoundingBox = BoundingBox(minimum: minimumCoordinate, maximum: maximumCoordinate)
        let secondBoundingBox = BoundingBox(minimum: minimumCoordinate, maximum: maximumCoordinate)
        
        XCTAssertEqual(firstBoundingBox, secondBoundingBox)
    }
    
    func testEquals_whenBoundingBoxesAreNotEqual_shouldReturnFalse() {
        let firstBoundingBox = BoundingBox(minimum: Coordinate(latitude: 0, longitude: 1),
                                           maximum: Coordinate(latitude: 2, longitude: 3))
        let secondBoundingBox = BoundingBox(minimum: Coordinate(latitude: 4, longitude: 5),
                                            maximum: Coordinate(latitude: 6, longitude: 7))
        
        XCTAssertNotEqual(firstBoundingBox, secondBoundingBox)
    }

}
