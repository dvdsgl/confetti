import Foundation

import ConfettiKit
import Firebase

// TODO Figure out how to get this into ConfettiKit
// I couldn't figure out how to link Firebase twice
public class UserViewModel {
    
    public static let current = UserViewModel()
    
    var db: DatabaseReference!
    
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
        db = Database.database().reference()
        
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
