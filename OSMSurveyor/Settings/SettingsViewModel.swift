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
}
