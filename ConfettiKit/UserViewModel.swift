import Foundation
import UserNotifications

import ConfettiKit

import Firebase
import FirebasePerformance

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
    
    public private(set) var events: [Event]?
    
    func logout() {
        if AppDelegate.shared.runMode == .testRun && userAuth.isAnonymous {
            userNode.removeValue()
            userAuth.delete()
        }
        try! Auth.auth().signOut()
    }
    
    private init() {
        db = Database.database().reference()
        
        var user = [AnyHashable: Any]()
        if let email = userAuth.email {
            user["email"] = email
        }
        userNode.updateChildValues(user)
        
        onEventsUpdated { events in
            self.events = events
            Notifications.EventsChanged.post(sender: self, events: events)
        }
    }
    
    func onEventsChanged(_ onEventsUpdated: @escaping ([Event]) -> ()) -> NotificationRegistration {
        if let events = events {
            onEventsUpdated(events)
        }
        return Notifications.EventsChanged.subscribe(onEventsUpdated)
    }


    private func onEventsUpdated(_ success: @escaping ([Event]) -> ()) {
        let trace = Performance.startTrace(name: "UserViewModel.getEvents")
        
        eventsNode.observe(.value, with: { snapshot in
            trace?.stop()
            
            var events = [Event]()
            for eventNode in snapshot.children.allObjects as! [DataSnapshot] {
                if let eventDict = eventNode.value as? [String: Any?] {
                    if let event = Event.fromFirebaseValue(eventDict) {
                        event.key = eventNode.key
                        events.append(event)
                    }
                }
            }
            success(events)
        })
    }
    
    public func addEvent(_ event: Event) {
        let child = eventsNode.childByAutoId()
        event.key = child.key
        child.setValue(event.firebaseValue)
    }
    
    public func deleteEvent(_ event: Event) {
        guard let key = event.key else { return }
        eventsNode.child(key).removeValue()
    }
    
    func updateEvent(_ event: Event) {
        guard let key = event.key else { return }
        eventsNode.child(key).setValue(event.firebaseValue)
    }
}
