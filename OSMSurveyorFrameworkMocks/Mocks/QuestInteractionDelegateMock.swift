//
//  QuestInteractionDelegateMock.swift
//  OSMSurveyorFrameworkMocks
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

@testable import OSMSurveyorFramework

final class QuestInteractionDelegateMock {
    private(set) var didCallPresentBooleanQuestInterface = false
    private(set) var presentBooleanQuestInterfaceArguments: (question: String, completion: (Bool) -> Void)?
}

extension QuestInteractionDelegateMock: QuestInteractionDelegate {
    func presentBooleanQuestInterface(question: String, completion: @escaping (Bool) -> Void) {
        didCallPresentBooleanQuestInterface = true
        
        presentBooleanQuestInterfaceArguments = (question, completion)
    }
}
