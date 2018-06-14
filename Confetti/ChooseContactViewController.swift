import Foundation
import UIKit

import ConfettiKit

import Contacts
import ContactsUI

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
    
    let contactStore: ContactStore = {
        switch AppDelegate.shared.runMode {
        case .testRun:
            return TestContactStore()
        default:
            return NativeContactStore()
        }
    }()
    
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
    
    func createManualContact(name: String) -> Contact {
        let names = name.components(separatedBy: " ")
        switch names.count {
        case 0, 1:
            return ManualContact(firstName: name)
        default:
            let first = names[0]
            let rest = names.dropFirst().joined(separator: " ")
            return ManualContact(firstName: first, lastName: rest, nick: nil, imageSource: nil)
        }
    }
    
    func searchContacts(query: String?) {
        let searchText = query ?? ""
        contacts = contactStore.search(query: searchText)
        contacts.append(createManualContact(name: searchText))
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactTableViewCell
        cell.contact = contacts[indexPath.row]
        if cell.contact is ManualContact {
            cell.nameLabel.textColor = Colors.pink
        } else {
            cell.nameLabel.textColor = UIColor.darkText
        }
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


