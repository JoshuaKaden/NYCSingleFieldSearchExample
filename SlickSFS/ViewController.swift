//
//  ViewController.swift
//  SlickSFS
//
//  Created by Kaden, Joshua on 5/22/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private var isSearching = false
    private let mapViewController = MapViewController()
    private let resultsViewController = ResultsViewController()
    private let searchController: UISearchController
    private var selectedLocation: Location?
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
        
        definesPresentationContext = true
        
        resultsViewController.delegate = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        view.addSubview(searchController.searchBar)
        
        searchController.searchResultsUpdater = self
        
        adoptChildViewController(mapViewController)
    }
    
    deinit {
        mapViewController.leaveParentViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isSearching {
            searchController.searchBar.y = 0
        } else {
            searchController.searchBar.y = UIApplication.shared.statusBarFrame.height
        }
        
        mapViewController.view.y = searchController.searchBar.maxY
        mapViewController.view.height = view.height - mapViewController.view.y
    }
    
}

// MARK: - ResultsViewControllerDelegate

extension ViewController: ResultsViewControllerDelegate {
    func didSelect(location: Location) {
        selectedLocation = location
        mapViewController.location = location
        searchController.isActive = false
        isSearching = false
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
                self.resultsViewController.locations = locations
            case let .error(error):
                print(error)
            }
        }
    }
}
