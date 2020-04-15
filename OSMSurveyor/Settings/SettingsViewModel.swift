//
//  SettingsViewModel.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import OSMSurveyorFramework

final class SettingsViewModel {
    
    // MARK: Types
    
    /// Enum that controls the sections that are being displayed.
    enum SectionIndex: Int, CaseIterable {
        case accounts
        case help
    }
    
    // MARK: Public properties
    
    weak var coordinator: SettingsCoordinatorProtocol?
    weak var delegate: TableViewModelDelegate?
    
    // MARK: Private properties
    
    private let keychainHandler: KeychainHandling
    private let notificationCenter: NotificationCenter
    private let appNameAndVersion: String
    
    private var sections = [Table.Section]()
    
    // MARK: Initializer
    
    init(keychainHandler: KeychainHandling,
         notificationCenter: NotificationCenter = .default,
         appName: String,
         appVersion: String,
         appBuildNumber: String) {
        self.keychainHandler = keychainHandler
        self.notificationCenter = notificationCenter
        
        appNameAndVersion = "\(appName) \(appVersion) (Build \(appBuildNumber))"
        
        sections = createSections()
        
        startToObserveNotificationCenter()
    }
    
    convenience init() {
        guard
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let appBuildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            fatalError("Unable to get the app details from the info dictionary.")
        }
        
        self.init(keychainHandler: KeychainHandler(), appName: appName, appVersion: appVersion, appBuildNumber: appBuildNumber)
    }
    
    // MARK: Private methods
    
    private func createSections() -> [Table.Section] {
        return SectionIndex.allCases.map { sectionIndex in
            switch sectionIndex {
            case .accounts:
                return createAccountsSection()
            case .help:
                return createHelpSection()
            }
        }
    }
    
    private func createAccountsSection() -> Table.Section {
        let accountRows = keychainHandler.entries.map { keychainEntry in
            Table.Row(title: keychainEntry.username,
                      accessoryType: .disclosureIndicator)
        }
        
        let addAccountRow = Table.Row(title: "Add Account",
                                      accessoryType: .disclosureIndicator)
        
        let allRows = accountRows + [addAccountRow]
        
        return Table.Section(headerTitle: "OpenStreetMap Accounts",
                             rows: allRows)
    }
    
    private func createHelpSection() -> Table.Section {
        let rows = [
            Table.Row(title: "GitHub Repository"),
            Table.Row(title: "Bug Tracker")
        ]
        
        return Table.Section(headerTitle: "Help",
                             footerTitle: appNameAndVersion,
                             rows: rows)
    }
    
    private func section(at index: Int) -> Table.Section? {
        guard SectionIndex(rawValue: index) != nil else { return nil }
        
        return sections[index]
    }
    
    private func startToObserveNotificationCenter() {
        notificationCenter.addObserver(forName: Notification.Name.keychainHandlerDidChangeNumberOfEntries, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            
            /// Re-create all sections so that when the delegate reloads the section, the view model reports updated data.
            self.sections = self.createSections()
            
            self.delegate?.reloadSection(SectionIndex.accounts.rawValue)
        }
    }
}

extension SettingsViewModel: TableViewModelProtocol {
    func numberOfSections() -> Int {
        return SectionIndex.allCases.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.section(at: section)?.rows.count ?? 0
    }
    
    func row(at indexPath: IndexPath) -> Table.Row? {
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
        guard let sectionIndex = SectionIndex(rawValue: indexPath.section) else { return }
        
        switch sectionIndex {
        case .accounts:
            let indexOfLastRow = numberOfRows(in: indexPath.section) - 1
            
            if indexPath.row == indexOfLastRow {
                coordinator?.startAddAccountFlow()
            } else {
                let username = keychainHandler.entries[indexPath.row].username
                
                coordinator?.askForConfirmationToRemoveAccount(username: username) { [weak self] in
                    self?.keychainHandler.remove(username: username)
                }
            }
        case .help:
            if indexPath.row == 0 {
                coordinator?.presentGitHubRepository()
            } else if indexPath.row == 1 {
                coordinator?.presentBugTracker()
            }
        }
    }
}
