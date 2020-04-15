//
//  Table.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

struct Table {
    // MARK: Types
    
    struct Row {
        enum AccessoryType {
            case none
            case disclosureIndicator
            case checkmark
        }
        
        let title: String
        let accessoryType: AccessoryType
        
        init(title: String, accessoryType: AccessoryType = .none) {
            self.title = title
            self.accessoryType = accessoryType
        }
    }
    
    struct Section {
        let headerTitle: String?
        let footerTitle: String?
        let rows: [Row]
        
        init(headerTitle: String? = nil,
             footerTitle: String? = nil,
             rows: [Row] = [Row]()) {
            self.headerTitle = headerTitle
            self.footerTitle = footerTitle
            self.rows = rows
        }
    }
}
