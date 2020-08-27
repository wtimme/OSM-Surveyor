//
//  LocationSearchViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 27.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import OSMSurveyorFramework
import UIKit

class LocationSearchViewController: UITableViewController {
    // MARK: Private types

    private struct SearchResult {
        let title: String
        let coordinate: Coordinate
    }

    // MARK: Private properties

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async { [weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
        }
    }

    // MARK: Private methods

    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Name or address of a place"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_: UISearchBar) {
        dismiss(animated: true)
    }
}
