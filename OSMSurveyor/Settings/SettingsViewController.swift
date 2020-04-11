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
         viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(didTapDoneButton))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultTableViewCellReuseIdentifier)
    }
    
    // MARK: UITableViewDataSource and delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultTableViewCellReuseIdentifier, for: indexPath)
        
        if let row = viewModel.row(at: indexPath) {
            cell.textLabel?.text = row.title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitleOfSection(section)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.footerTitleOfSection(section)
    }
    
    // MARK: Private method
    
    @objc private func didTapDoneButton() {
        dismiss(animated: true)
    }
}
