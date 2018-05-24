//
//  ViewController.swift
//  SlickSFS
//
//  Created by Kaden, Joshua on 5/22/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var isSearching = false
    private var locations: [Location] = []
    private let resultsViewController = UITableViewController()
    private let searchController: UISearchController
    private let singleFieldSearchClient = SingleFieldSearchClient()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        searchController = UISearchController(searchResultsController: resultsViewController)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        searchController = UISearchController(searchResultsController: resultsViewController)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        view.addSubview(searchController.searchBar)
        
        resultsViewController.tableView.dataSource = self
        
        definesPresentationContext = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isSearching {
            searchController.searchBar.y = 0
        } else {
            searchController.searchBar.y = UIApplication.shared.statusBarFrame.height
        }
    }
    
}

// MARK: - UISearchBarDelegate {

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}

// MARK: - UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let searchString = "\(text)"
        singleFieldSearchClient.performSingleFieldSearch(searchString) {
            result in
            switch result {
            case let .success(locations):
                print("\(locations.count) locations returned")
                self.locations = locations
                self.resultsViewController.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeued = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeued
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.accessoryType = .disclosureIndicator
        }
        
        let location = locations[indexPath.row]
        cell.textLabel?.text = location.formattedAddressLines[0]
        if location.formattedAddressLines.count > 1 {
            cell.detailTextLabel?.text = location.formattedAddressLines[1]
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
