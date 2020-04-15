//
//  UploadViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

class UploadViewController: UITableViewController {

    // MARK: Private properties
    
    private(set) var viewModel: TableViewModelProtocol
    
    private let defaultTableViewCellReuseIdentifier = "defaultTableViewCellReuseIdentifier"
    
    // MARK: Initializer
    
    init(style: UITableView.Style = .insetGrouped,
         viewModel: TableViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Prepare upload"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancelButton))
        
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
            
            switch row.accessoryType {
            case .disclosureIndicator:
                cell.accessoryType = .disclosureIndicator
            case .checkmark:
                cell.accessoryType = .checkmark
            case .none:
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitleOfSection(section)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.footerTitleOfSection(section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath)
        
        /// Immediately deselect the row again, so that it doesn't visually stay selected.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Private method
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }

}
