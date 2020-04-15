//
//  AlertPresenting.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

/// An object that presents simple information in the form of alerts.
protocol AlertPresenting {
    /// Presents an alert.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    func presentAlert(title: String, message: String)
}

extension AlertPresenting where Self: UIViewController {
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}

extension UIViewController: AlertPresenting {}
