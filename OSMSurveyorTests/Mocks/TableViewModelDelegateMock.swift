//
//  TableViewModelDelegate.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 12.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyor

final class TableViewModelDelegateMock {
    private(set) var didCallReloadReloadSection = false
    private(set) var sectionToReload: Int?
}

extension TableViewModelDelegateMock: TableViewModelDelegate {
    func reloadSection(_ section: Int) {
        didCallReloadReloadSection = true

        sectionToReload = section
    }
}
