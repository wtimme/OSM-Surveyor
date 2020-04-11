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
    
    struct Row {
        let title: String
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
    
    // MARK: Public properties
    
    weak var coordinator: SettingsCoordinatorProtocol?
    
    // MARK: Private properties
    
    private let appNameAndVersion: String
    
    private var sections = [Section]()
    
    // MARK: Initializer
    
    init(appName: String, appVersion: String, appBuildNumber: String) {
        appNameAndVersion = "\(appName) \(appVersion) (Build \(appBuildNumber))"
        
        sections = [createHelpSection()]
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
    
    // MARK: Public methods
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.section(at: section)?.rows.count ?? 0
    }
    
    func row(at indexPath: IndexPath) -> Row? {
        guard
            let section = self.section(at: indexPath.section),
            indexPath.row >= 0,
            indexPath.row < section.rows.count
        else {
            /// Invalid index path.
            return nil
        }
        
        return section.rows[indexPath.row]
    }
    
    func headerTitleOfSection(_ section: Int) -> String? {
        return self.section(at: section)?.headerTitle
    }
    
    func footerTitleOfSection(_ section: Int) -> String? {
        return self.section(at: section)?.footerTitle
    }
    
    func selectRow(at indexPath: IndexPath) {
    }
    
    // MARK: Private methods
    
    private func createHelpSection() -> Section {
        let rows = [
            Row(title: "GitHub Repository"),
            Row(title: "Bug Tracker")
        ]
        
        return Section(headerTitle: "Help",
                       footerTitle: appNameAndVersion,
                       rows: rows)
    }
    
    private func section(at index: Int) -> Section? {
        guard index >= 0, index < numberOfSections() else { return nil }
        
        return sections[index]
    }
}
