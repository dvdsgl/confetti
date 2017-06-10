import Foundation
import UIKit

import ConfettiKit

import Contacts
import ContactsUI

extension CNContact: Contact {
    public var firstName: String { return givenName }
    public var lastName: String { return familyName }
    
    public var fullName: String {
        return CNContactFormatter.string(from: self, style: .fullName)!
    }
}

extension UIImage {
    class func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

class ChooseContactViewController : UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var createEventSpec: CreateEventSpec!
    var contacts = [Contact]()
    
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
    
    override func viewDidLoad() {
        title = createEventSpec.title
        
        // Get rid of nav bar shadow for a nice, continuous look
        if let bar = navigationController?.navigationBar {
            bar.shadowImage = UIImage()
            bar.setBackgroundImage(UIImage(), for: .default)
            
            searchBar.setBackgroundImage(UIImage.image(with: Colors.cyan), for: .any, barMetrics: .default)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchContacts(query: nil)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContacts(query: searchText)
    }
    
    func searchContacts(query: String?) {
        let searchText = query ?? ""
        
        if AppDelegate.shared.runMode == .testRun {
            contacts = [ManualContact(firstName: "John", lastName: "Appleseed")]
            tableView.reloadData()
            return
        }
        
        let store = CNContactStore()
        let predicate: NSPredicate
        
        if searchText.isEmpty {
            predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
        } else {
            predicate = CNContact.predicateForContacts(matchingName: searchText)
        }
        do {
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            tableView.reloadData()
        }
        catch {
            print("Error!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactTableViewCell
        cell.contact = contacts[indexPath.row]
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDetail":
            if let indexPath = tableView.indexPathForSelectedRow {
                let contact = contacts[indexPath.row]
                let controller = segue.destination as! CreateEventViewController
                controller.contact = contact
                controller.createEventSpec = createEventSpec
            }
        default:
            return
        }
    }
 }


