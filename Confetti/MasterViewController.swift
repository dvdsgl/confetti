import UIKit
import ConfettiKit

import Firebase
import SwiftyJSON

public typealias FirebaseValue = [String: Any?]

public protocol FirebaseData {
    associatedtype Model
    
    var firebaseValue: FirebaseValue { get }
    static func fromFirebaseValue(_ value: FirebaseValue) -> Model?
}

extension FirebaseData {
    // When parsing an object as property of other FirebaseValue
    static func fromFirebaseValueAny(_ value: Any??) -> Model? {
        return fromFirebaseValue(value as! FirebaseValue)
    }
}

extension Event: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return [
            "person": person.firebaseValue,
            "occasion": occasion.firebaseValue
        ]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Event? {
        return Event(
            person: Person.fromFirebaseValueAny(value["person"])!,
            occasion: Occasion.fromFirebaseValueAny(value["occasion"])!
        )
    }
}

extension Person: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return [
            "firstName": firstName,
            "photoUrl": photoUrl
        ]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Person? {
        return Person(
            firstName: value["firstName"] as! String,
            photoUrl: value["photoUrl"] as? String
        )
    }
}

extension Occasion: FirebaseData {
    public var firebaseValue: FirebaseValue {
        switch self {
        case let .birthday(month, day, year):
            return [
                "case": "birthday",
                "day": day,
                "month": month,
                "year": year
            ]
        case let .holiday(holiday):
            return [
                "case": "holiday",
                "holiday": holiday.firebaseValue
            ]
        case let .anniversary(month, day, year):
            return [
                "case": "anniversary",
                "day": day,
                "month": month,
                "year": year
            ]
        }
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Occasion? {
        switch value["case"] as! String {
        case "birthday":
            return .birthday(
                month: value["month"] as! Int,
                day: value["day"] as! Int,
                year: value["year"] as? Int
            )
        case "holiday":
            return .holiday(
                holiday: Holiday.fromFirebaseValueAny(value["holiday"])!
            )
        case "anniversary":
            return .anniversary(
                month: value["month"] as! Int,
                day: value["day"] as! Int,
                year: value["year"] as? Int
            )
        default:
            return nil
        }
    }
}

extension Holiday: FirebaseData {
    public var firebaseValue: FirebaseValue {
        switch self {
        case .mothersDay:
            return ["case": "mothersDay"]
        case .fathersDay:
            return ["case": "fathersDay"]
        }
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Holiday? {
        switch value["case"] as! String {
        case "mothersDay":
            return .mothersDay
        case "fathersDay":
            return .fathersDay
        default:
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
    
    public func getEvents(_ success: @escaping ([Event]) -> ()) {
        eventsNode.observeSingleEvent(of: .value, with: { snapshot in
            var events = [Event]()
            for eventNode in snapshot.children.allObjects as! [DataSnapshot] {
                if let eventDict = eventNode.value as? [String: Any?] {
                    if let event = Event.fromFirebaseValue(eventDict) {
                        events.append(event)
                    }
                }
            }
            success(events)
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

