//
//  QuestAnnotationManagerTestCase.swift
//  OSMSurveyorFrameworkTests
//
//  Created by Wolfgang Timme on 07.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyorFramework

class QuestAnnotationManagerTestCase: XCTestCase {
    
    private var manager: QuestAnnotationManaging!
    private var fullQuestsDataProviderMock: FullQuestsDataProviderMock!
    
    private var delegateMock: QuestAnnotationManagerDelegateMock!

    override func setUpWithError() throws {
        fullQuestsDataProviderMock = FullQuestsDataProviderMock()
        
        manager = QuestAnnotationManager(fullQuestsDataProvider: fullQuestsDataProviderMock)
        
        delegateMock = QuestAnnotationManagerDelegateMock()
        manager.delegate = delegateMock
    }

    override func tearDownWithError() throws {
        manager = nil
        fullQuestsDataProviderMock = nil
        
        delegateMock = nil
    }

}
