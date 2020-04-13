//
//  UploadViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

class UploadViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Prepare upload"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancelButton))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    // MARK: Private method
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }

}
