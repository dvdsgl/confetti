//
//  ChooseContactViewController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/26/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class ChooseContactViewController : UITableViewController {
    
    var contacts = [CNContact]()
    let contactStore = CNContactStore()
    
    override func viewDidLoad() {
        getContacts()
    }
    
    func getContacts() {
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let contact = self.contacts[indexPath.row]
        let formatter = CNContactFormatter()
        
        cell.textLabel?.text = formatter.string(from: contact)
        cell.detailTextLabel?.text = contact.emailAddresses.first?.value as String?
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
}


