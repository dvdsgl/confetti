import UIKit
import ConfettiKit

import Firebase
import SwiftyJSON

public protocol FirebaseData {
    associatedtype Model
    
    var json: JSON { get }
    static func fromJSON(_ json: JSON) -> Model?
}

extension FirebaseData {
    public var firebaseValue: Any {
        return json.object
    }
}

extension Event: FirebaseData {
    public var json: JSON {
        return [
            "person": person.json,
            "occasion": occasion.json
        ]
    }
    
    public static func fromJSON(_ json: JSON) -> Event? {
        return Event(
            person: Person.fromJSON(json["person"])!,
            occasion: Occasion.fromJSON(json["occasion"])!
        )
    }
}

extension Person: FirebaseData {
    public var json: JSON {
        return [
            "firstName": firstName,
            "photoUrl": photoUrl as Any
        ]
    }
    
    public static func fromJSON(_ json: JSON) -> Person? {
        return Person(
            firstName: json["firstName"].string!,
            photoUrl: json["photoUrl"].string
        )
    }
}

extension Occasion: FirebaseData {
    public var json: JSON {
        switch self {
        case let .birthday(month, day, year):
            return [
                "case": "birthday",
                "day": day,
                "month": month,
                "year": year as Any
            ]
        case let .holiday(holiday):
            return [
                "case": "holiday",
                "holiday": holiday.json
            ]
        case let .anniversary(month, day, year):
            return [
                "case": "anniversary",
                "day": day,
                "month": month,
                "year": year as Any
            ]
        }
    }
    
    public static func fromJSON(_ json: JSON) -> Occasion? {
        switch json["case"].string! {
        case "birthday":
            return .birthday(
                month: json["month"].int!,
                day: json["day"].int!,
                year: json["year"].int
            )
        case "holiday":
            return .holiday(
                holiday: Holiday.fromJSON(json["holiday"])!
            )
        case "anniversary":
            return .anniversary(
                month: json["month"].int!,
                day: json["day"].int!,
                year: json["year"].int
            )
        default:
            return nil
        }
    }
}

extension Holiday: FirebaseData {
    public var json: JSON {
        switch self {
        case .mothersDay:
            return "mothersDay"
        case .fathersDay:
            return "fathersDay"
        }
    }
    
    public static func fromJSON(_ json: JSON) -> Holiday? {
        if let stringRep = json.string {
            switch stringRep {
            case "mothersDay":
                return .mothersDay
            case "fathersDay":
                return .fathersDay
            default:
                return nil
            }
        } else {
            return nil
        }
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
    
    var eventsNode: DatabaseReference {
        return userNode.child("events")
    }
    
    private init() {
        userNode.updateChildValues([
            "email": userAuth.email!
        ])
    }
    
    public func getEvents(_ success: @escaping ([[String: Any?]]) -> ()) {
        eventsNode.observeSingleEvent(of: .value, with: { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let d = rest.value as? [String: Any?]
                print(d)
            }
            success([])
        })
    }
    
    public func addEvent(_ event: Event) {
        eventsNode.childByAutoId().setValue(event.firebaseValue)
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
        user.getEvents { (events) in
            print(events)
        }
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

