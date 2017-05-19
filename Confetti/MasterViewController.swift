import UIKit
import ConfettiKit

import Firebase
import SwiftyJSON

public protocol FirebaseData {
    associatedtype Model
    
    var json: JSON { get }
    static func fromJSON(_ json: JSON) -> Model
}

extension FirebaseData {
    public var firebaseDictionary: [String: Any?] {
        return json.dictionaryObject!
    }
}

extension Event: FirebaseData {
    public var json: JSON {
        return [
            "person": person.firstName,
            "occasion": String(describing: occasion)
        ]
    }
    
    public static func fromJSON(_ json: JSON) -> Event {
        let person = Person(firstName: json["person"].string!)
        let occasion = Occasion.holiday(holiday: .mothersDay)
        return Event(person: person, occasion: occasion)
    }
}

class UserViewModel {
    
    public static let currentUser = UserViewModel()
    
    let db = Database.database().reference()
    
    var userAuth: User {
        return Auth.auth().currentUser!
    }
    
    var userNode: DatabaseReference {
        return db.child("users").child(userAuth.uid)
    }
    
    private init() {
        userNode.updateChildValues([
            "email": userAuth.email!
        ])
    }
    
    public func getEvents(_ success: @escaping ([[String: Any?]]) -> ()) {
        userNode.child("events").observe(.value, with: { (snapshot) in
            let events = snapshot.value as? [[String : Any?]] ?? []
            success(events)
        })
    }
    
    public func addEvent(_ event: Event) {
        userNode.child("events").childByAutoId().setValue(event.firebaseDictionary)
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = Events.samples.sorted(by: { $0.daysAway < $1.daysAway })
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
        navigationItem.rightBarButtonItem = addButton
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logOut(_:)))
        getData()
    }
    
    func getData() {
        let user = UserViewModel.currentUser
        user.addEvent(objects[0].event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }

    func insertNewObject(_ sender: Any) {
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        
        //cell.photoView!.configuration = AvatarImageViewConfiguration()
        

        let event = objects[indexPath.row]
        cell.setEvent(event)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(EventTableViewCell.defaultHeight);
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

