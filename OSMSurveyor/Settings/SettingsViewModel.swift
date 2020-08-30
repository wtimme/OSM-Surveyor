//
//  SettingsViewModel.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import OSMSurveyorFramework

protocol SettingsViewModelDelegate: AnyObject {
    func reloadAccountSection(section: Int)
}

final class SettingsViewModel {
    // MARK: Types

    struct Row {
        enum AccessoryType {
            case none
            case disclosureIndicator
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
             rows: [Row] = [Row]())
        {
            self.headerTitle = headerTitle
            self.footerTitle = footerTitle
            self.rows = rows
        }
    }

    // MARK: Public properties

    weak var coordinator: SettingsCoordinatorProtocol?
    weak var delegate: SettingsViewModelDelegate?

    // MARK: Private properties

    private let keychainHandler: KeychainHandling
    private let notificationCenter: NotificationCenter
    private let appNameAndVersion: String

    private var sections = [Section]()

    // MARK: Initializer

    init(keychainHandler: KeychainHandling,
         notificationCenter: NotificationCenter = .default,
         appName: String,
         appVersion: String,
         appBuildNumber: String)
    {
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

        self.init(keychainHandler: KeychainHandler(service: "api.openstreetmap.org"), appName: appName, appVersion: appVersion, appBuildNumber: appBuildNumber)
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
        let accountSection = 0
        let helpSection = numberOfSections() - 1

        if indexPath.section == accountSection {
            let indexOfLastRow = numberOfRows(in: accountSection) - 1

            if indexPath.row == indexOfLastRow {
                coordinator?.startAddAccountFlow()
            } else {
                let username = keychainHandler.entries[indexPath.row].username

                coordinator?.askForConfirmationToRemoveAccount(username: username) { [weak self] in
                    self?.keychainHandler.remove(username: username)
                }
            }
        } else if indexPath.section == helpSection {
            if indexPath.row == 0 {
                coordinator?.presentGitHubRepository()
            } else if indexPath.row == 1 {
                coordinator?.presentBugTracker()
            } else if indexPath.row == 2 {
                coordinator?.presentPrivacyStatement()
            }
        }
    }

    // MARK: Private methods

    private func createSections() -> [Section] {
        return [
            createAccountsSection(),
            createHelpSection(),
        ]
    }

    private func createAccountsSection() -> Section {
        let accountRows = keychainHandler.entries.map { keychainEntry in
            Row(title: keychainEntry.username,
                accessoryType: .disclosureIndicator)
        }

        let addAccountRow = Row(title: "Add Account",
                                accessoryType: .disclosureIndicator)

        let allRows = accountRows + [addAccountRow]

        return Section(headerTitle: "OpenStreetMap Accounts",
                       rows: allRows)
    }

    private func createHelpSection() -> Section {
        let rows = [
            Row(title: "GitHub Repository"),
            Row(title: "Bug Tracker"),
            Row(title: "Privacy Statement"),
        ]

        return Section(headerTitle: "Help",
                       footerTitle: appNameAndVersion,
                       rows: rows)
    }

    private func section(at index: Int) -> Section? {
        guard index >= 0, index < numberOfSections() else { return nil }

        return sections[index]
    }

    private func startToObserveNotificationCenter() {
        notificationCenter.addObserver(forName: Notification.Name.keychainHandlerDidChangeNumberOfEntries, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }

            /// Re-create all sections so that when the delegate reloads the section, the view model reports updated data.
            self.sections = self.createSections()

            self.delegate?.reloadAccountSection(section: 0)
        }
    }
}
