//
//  ResultsTableController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/27/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ResultsTableController: BaseTableViewController {
    
    // MARK: - Properties
    
    var filteredContacts = [CNContact]()
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier)!
        
        let contact = filteredContacts[indexPath.row]
        configureCell(cell, forContact: contact)
        
        return cell
    }
}
