//
//  UploadFlowCoordinator.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol UploadFlowCoordinatorProtocol {
    func start(questType: String, questId: Int)
}

final class UploadFlowCoordinator {
}

extension UploadFlowCoordinator: UploadFlowCoordinatorProtocol {
    func start(questType: String, questId: Int) {
        /// TODO: Implement me.
    }
}
