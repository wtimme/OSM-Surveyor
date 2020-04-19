//
//  UploadViewModel.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import OSMSurveyorFramework

final class UploadViewModel {
    // MARK: Types
    
    /// Enum that controls the sections that are being displayed.
    enum SectionIndex: Int, CaseIterable {
        case accounts
    }
    
    // MARK: Public properties
    
    weak var coordinator: UploadFlowCoordinatorProtocol?
    weak var delegate: TableViewModelDelegate?
    
    // MARK: Private properties
    
    private let keychainHandler: KeychainHandling
    private let notificationCenter: NotificationCenter
    private let userDefaults: UserDefaults
    private let questId: Int
    
    private var sections = [Table.Section]()
    
    // MARK: Initializer
    
    init(keychainHandler: KeychainHandling = KeychainHandler(),
         notificationCenter: NotificationCenter = .default,
         userDefaults: UserDefaults = .standard,
         questId: Int) {
        self.keychainHandler = keychainHandler
        self.notificationCenter = notificationCenter
        self.userDefaults = userDefaults
        self.questId = questId
        
        sections = createSections()
        
        startToObserveNotificationCenter()
    }
    
    // MARK: Public methods
    
    func didTapUploadButton() {
        guard let keychainEntry = keychainHandler.entries.first else { return }
        
        coordinator?.startUpload(oAuthCredentials: keychainEntry.credentials)
    }
    
    // MARK: Private methods
    
    private func createSections() -> [Table.Section] {
        return SectionIndex.allCases.map { sectionIndex in
            switch sectionIndex {
            case .accounts:
                return createAccountsSection()
            }
        }
    }
    
    private func createAccountsSection() -> Table.Section {
        let accountRows: [Table.Row] = keychainHandler.entries.enumerated().map { (index, keychainEntry) in
            let accessoryType: Table.Row.AccessoryType
            if 0 == index {
                /// For now, act as if the first account is always selected.
                /// Later, we need to add logic to remember which one was selected.
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
            
            return Table.Row(title: keychainEntry.username,
                             accessoryType: accessoryType)
        }
        
        let addAccountRow = Table.Row(title: "Add Account",
                                      accessoryType: .disclosureIndicator)
        
        let allRows = accountRows + [addAccountRow]
        
        return Table.Section(headerTitle: "Select account",
                             rows: allRows)
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

extension UploadViewModel: TableViewModelProtocol {
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
            }
        }
    }
}
