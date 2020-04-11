//
//  SettingsViewModel.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

final class SettingsViewModel {
    // MARK: Types
    
    struct Section {
        let headerTitle: String?
        let footerTitle: String?
        
        init(headerTitle: String? = nil, footerTitle: String? = nil) {
            self.headerTitle = headerTitle
            self.footerTitle = footerTitle
        }
    }
    
    // MARK: Private properties
    
    private let appNameAndVersion: String
    
    // MARK: Initializer
    
    init(appName: String, appVersion: String, appBuildNumber: String) {
        appNameAndVersion = "\(appName) \(appVersion) (Build \(appBuildNumber))"
    }
    
    convenience init() {
        guard
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let appBuildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            fatalError("Unable to get the app details from the info dictionary.")
        }

        self.init(appName: appName, appVersion: appVersion, appBuildNumber: appBuildNumber)
    }
}
