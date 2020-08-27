//
//  SettingsViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 11.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {
    // MARK: Private properties

    private let viewModel: SettingsViewModel

    private let defaultTableViewCellReuseIdentifier = "defaultTableViewCellReuseIdentifier"

    init(style: UITableView.Style = .insetGrouped,
         viewModel: SettingsViewModel = SettingsViewModel())
    {
        self.viewModel = viewModel

        super.init(style: style)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(didTapDoneButton))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultTableViewCellReuseIdentifier)
    }

    // MARK: UITableViewDataSource and delegate

    override func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultTableViewCellReuseIdentifier, for: indexPath)

        if let row = viewModel.row(at: indexPath) {
            cell.textLabel?.text = row.title

            switch row.accessoryType {
            case .disclosureIndicator:
                cell.accessoryType = .disclosureIndicator
            case .none:
                cell.accessoryType = .none
            }
        }

        return cell
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitleOfSection(section)
    }

    override func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.footerTitleOfSection(section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath)

        /// Immediately deselect the row again, so that it doesn't visually stay selected.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Private method

    @objc private func didTapDoneButton() {
        dismiss(animated: true)
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func reloadAccountSection(section: Int) {
        tableView.reloadSections(IndexSet(arrayLiteral: section), with: .automatic)
    }
}
