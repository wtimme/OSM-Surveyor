//
//  UIViewController+QuestInteractionDelegate.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import OSMSurveyorFramework

extension UIViewController: QuestInteractionDelegate {
    public func presentBooleanQuestInterface(question: String,
                                             completion: @escaping (Bool) -> Void) {
        let alertControllerStyle: UIAlertController.Style
        if UIDevice.current.userInterfaceIdiom == .pad {
            /// On iPad, we need to use `.alert`. Otherwise, the app will crash.
            alertControllerStyle = .alert
        } else {
            alertControllerStyle = .actionSheet
        }
        
        let alertController = UIAlertController(title: question, message: nil, preferredStyle: alertControllerStyle)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            completion(false)
        }
        alertController.addAction(noAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
