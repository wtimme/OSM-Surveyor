//
//  ElementGeometryDataManagerMock.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 06.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyorFramework

final class ElementGeometryDataManagerMock {
    private(set) var didCallInsert = false
    private(set) var insertElement: ElementGeometry?
}

extension ElementGeometryDataManagerMock: ElementGeometryDataManaging {
    func insert(_ element: ElementGeometry) {
        didCallInsert = true

        insertElement = element
    }
}
