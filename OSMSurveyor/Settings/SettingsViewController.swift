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
    }
}
