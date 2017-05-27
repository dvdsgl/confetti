//
//  BaseTableViewController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/27/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class BaseTableViewController: UITableViewController {
    
    // MARK: - Types
    
    static let nibName = "TableCell"
    static let tableViewCellIdentifier = "cellID"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        tableView.register(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: UITableViewCell, forContact contact: CNContact) {
        cell.textLabel?.text = contact.givenName
    }
}
