//
//  LocationSearchViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 27.08.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import OSMSurveyorFramework
import UIKit

protocol LocationSearchDelegate: AnyObject {
    func didSelectLocation(coordinate: Coordinate, boundingBox: BoundingBox)
}

class LocationSearchViewController: UITableViewController {
    // MARK: Private properties

    private let resultProvider: NominatimResultProviding = NominatimResultProvider()
    private let searchController = UISearchController(searchResultsController: nil)

    private var searchResults = [NominatimResult]() {
        didSet {
            tableView.reloadData()
        }
    }

    private let cellReuseIdentifier = "searchResultCell"

    /// The work item for performing the search' URL request.
    private var searchWorkItem: DispatchWorkItem?

    // MARK: Public properties

    weak var delegate: LocationSearchDelegate?

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        setupSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async { [weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
        }
    }

    // MARK: UITableView delegate and data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        /// Make sure the text label can have multiple lines.
        cell.textLabel?.numberOfLines = 0

        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.displayName

        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let coordinate = Coordinate(latitude: selectedResult.latitude, longitude: selectedResult.longitude)
        delegate?.didSelectLocation(coordinate: coordinate,
                                    boundingBox: selectedResult.boundingBox)

        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Private methods

    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Name or address of a place"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    private func performSearchRequest(for term: String) {
        resultProvider.performSearch(term) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(nominatimResults):
                self.searchResults = nominatimResults
            case let .failure(error):
                print("Failed to search for locations: \(error.localizedDescription)")
            }
        }
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_: UISearchBar) {
        dismiss(animated: true)
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        /// Cancel any previously scheduled search.
        searchWorkItem?.cancel()

        /// Create a new work item for the new search text.
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearchRequest(for: searchText)
        }
        searchWorkItem = workItem

        /// Execute the work item with a delay.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: workItem)
    }
}
