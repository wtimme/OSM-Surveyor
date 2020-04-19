//
//  UploadFlowCoordinatorMock.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
@testable import OSMSurveyor
import OSMSurveyorFramework

final class UploadFlowCoordinatorMock {
    private(set) var didCallStart = false
    private(set) var startArguments: (questType: String, questId: Int)?
    
    private(set) var didCallStartAddAccountFlow = false
    
    private(set) var didCallStartUpload = false
    private(set) var oAuthCredentialsForUpload: OAuth1Credentials?
}

extension UploadFlowCoordinatorMock: UploadFlowCoordinatorProtocol {
    func start(questType: String, questId: Int) {
        didCallStart = true
        
        startArguments = (questType, questId)
    }
    
    func startAddAccountFlow() {
        didCallStartAddAccountFlow = true
    }
    
    func startUpload(oAuthCredentials: OAuth1Credentials) {
        didCallStartUpload = true
        
        oAuthCredentialsForUpload = oAuthCredentials
    }
}
