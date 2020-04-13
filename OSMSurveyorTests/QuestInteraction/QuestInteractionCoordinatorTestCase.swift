//
//  QuestInteractionCoordinatorTestCase.swift
//  OSMSurveyorTests
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import XCTest
@testable import OSMSurveyor
@testable import OSMSurveyorFramework
@testable import OSMSurveyorFrameworkMocks

class QuestInteractionCoordinatorTestCase: XCTestCase {
    
    private var coordinator: QuestInteractionCoordinatorProtocol!
    private var questInteractionProviderMock: QuestInteractionProviderMock!
    private var uploadFlowCoordinatorMock: UploadFlowCoordinatorMock!
    private var delegateMock: QuestInteractionDelegateMock!

    override func setUpWithError() throws {
        questInteractionProviderMock = QuestInteractionProviderMock()
        uploadFlowCoordinatorMock = UploadFlowCoordinatorMock()
        delegateMock = QuestInteractionDelegateMock()
        
        coordinator = QuestInteractionCoordinator(questInteractionProvider: questInteractionProviderMock,
                                                  uploadFlowCoordinator: uploadFlowCoordinatorMock,
                                                  delegate: delegateMock)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        questInteractionProviderMock = nil
        uploadFlowCoordinatorMock = nil
        delegateMock = nil
    }
    
    func testStart_shouldAskProviderForQuestInteraction() {
        /// Given
        let questType = "example_quest"
        
        /// When
        try? coordinator.start(questType: questType, questId: 0)
        
        /// Then
        XCTAssertTrue(questInteractionProviderMock.didCallQuestInteraction)
        XCTAssertEqual(questInteractionProviderMock.questTypeToRetrieveInteractionFor, questType)
    }
    
    func testStart_whenNoInteractionWasFound_shouldThrowAnError() {
        /// Given
        questInteractionProviderMock.questInteractionToReturn = nil
        
        do {
            try coordinator.start(questType: "", questId: 0)
            
            XCTFail("`start()` should've thrown an error")
        } catch QuestInteractionCoordinatorError.interactionNotFound {
            /// This is the expected outcome.
        } catch {
            /// Any other error is a failure.
            XCTFail()
        }
    }
    
    func testStart_whenInteractionTypeIsBoolean_shouldAskDelegateToPresentCorrespondingInterface() {
        /// Given
        let question = "Lorem ipsum?"
        let interaction = QuestInteraction(question: question,
                                           answerType: .boolean)
        questInteractionProviderMock.questInteractionToReturn = interaction
        
        /// When
        try? coordinator.start(questType: "", questId: 0)
        
        /// Then
        XCTAssertTrue(delegateMock.didCallPresentBooleanQuestInterface)
        XCTAssertEqual(delegateMock.presentBooleanQuestInterfaceArguments?.question, question)
    }
    
    func testStart_whenAnsweringQuestOfTypeBoolean_shouldAskUploadFlowCoordinatorToStart() {
        /// Given
        let questType = "example_quest"
        let questId = 42
        
        questInteractionProviderMock.questInteractionToReturn = QuestInteraction.makeQuestInteraction(answerType: .boolean)
        
        /// When
        try? coordinator.start(questType: questType, questId: questId)
        delegateMock.presentBooleanQuestInterfaceArguments?.answer(true)
        
        /// Then
        XCTAssertTrue(uploadFlowCoordinatorMock.didCallStart)
        XCTAssertEqual(uploadFlowCoordinatorMock.startArguments?.questType, questType)
        XCTAssertEqual(uploadFlowCoordinatorMock.startArguments?.questId, questId)
    }

}
