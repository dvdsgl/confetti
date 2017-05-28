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
    static let tableViewCellIdentifier = "contactCell"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: UITableViewCell, forContact contact: CNContact) {
        cell.textLabel?.text = contact.namePrefix + " " + contact.givenName + " " + contact.familyName + " " + contact.nameSuffix
    }
}
