//
//  ResultsViewController.swift
//  SlickSFS
//
//  Created by Kaden, Joshua on 5/24/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

protocol ResultsViewControllerDelegate: class {
    func didSelect(location: Location)
}

final class ResultsViewController: UITableViewController {
    
    var delegate: ResultsViewControllerDelegate?
    
    var locations: [Location] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension ResultsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeued = tableView.dequeueReusableCell(withIdentifier: "resultsCell") {
            cell = dequeued
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "resultsCell")
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

extension ResultsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        delegate?.didSelect(location: location)
    }
}
