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
import ConfettiKit

class ChooseContactViewController : BaseTableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    var contacts = [CNContact]()
    var filteredContacts = [CNContact]()
    let contactStore = CNContactStore()
    
    let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactNameSuffixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor]
    
    /********* Set Up Search Bar *********/
    
    /// State restoration values.
    enum RestorationKeys : String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
    }
    
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    // MARK: - Properties
    
    /*
     The following 2 properties are set in viewDidLoad(),
     They are implicitly unwrapped optionals because they are used in many other places throughout this view controller.
     */
    
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    
    /// Secondary search results table view.
    var resultsTableController: ResultsTableController!
    
    /// Restoration state for UISearchController
    var restoredState = SearchControllerRestorableState()

    /********* End Set Up Search Bar *********/
    
    override func viewDidLoad() {
        getContacts()
        
        /********* Set Up Search Bar *********/
        resultsTableController = ResultsTableController()
        
        // We want ourselves to be the delegate for this filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = Colors.mediumAquamarine
        searchController.searchBar.tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        definesPresentationContext = true

        /********* End Set Up Search Bar *********/
    }
    
    func getContacts() {
        
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
    
    /********* Set Up Search Bar *********/
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Restore the searchController's active state.
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    open func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = searchController.searchBar.text , searchController.isActive {
            
            let predicate: NSPredicate
            if searchText.characters.count > 0 {
                predicate = CNContact.predicateForContacts(matchingName: searchText)
            } else {
                predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStore.defaultContainerIdentifier())
            }
            
            let store = CNContactStore()
            do {
                filteredContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
                resultsTableController.filteredContacts = filteredContacts
                resultsTableController.tableView.reloadData()
            }
            catch {
                print("Error!")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)
        
        let contact = contacts[indexPath.row]
        configureCell(cell, forContact: contact)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact: CNContact
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            selectedContact = contacts[indexPath.row]
        }
        else {
            selectedContact = resultsTableController.filteredContacts[indexPath.row]
        }
        
        // Set up the detail view controller to show.
        let detailViewController = CreateEventViewController.createEventViewController(selectedContact)
        
        print(selectedContact)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - UIStateRestoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        // Encode the view state so it can be restored later.
        
        // Encode the title.
        coder.encode(navigationItem.title!, forKey:RestorationKeys.viewControllerTitle.rawValue)
        
        // Encode the search controller's active state.
        coder.encode(searchController.isActive, forKey:RestorationKeys.searchControllerIsActive.rawValue)
        
        // Encode the first responser status.
        coder.encode(searchController.searchBar.isFirstResponder, forKey:RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        // Encode the search bar text.
        coder.encode(searchController.searchBar.text, forKey:RestorationKeys.searchBarText.rawValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        // Restore the title.
        guard let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String else {
            fatalError("A title did not exist. In your app, handle this gracefully.")
        }
        title = decodedTitle
        
        // Restore the active state:
        // We can't make the searchController active here since it's not part of the view
        // hierarchy yet, instead we do it in viewWillAppear.
        //
        restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
        
        // Restore the first responder status:
        // Like above, we can't make the searchController first responder here since it's not part of the view
        // hierarchy yet, instead we do it in viewWillAppear.
        //
        restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        // Restore the text in the search field.
        searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
    }
    
    /********* End Set Up Search Bar *********/
    
 }


