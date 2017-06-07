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
    
    var events: [Event]?
    
    private init() {
        db = Database.database().reference()
        
        var user = [AnyHashable: Any]()
        if let email = userAuth.email {
            user["email"] = email
        }
        userNode.updateChildValues(user)
        
        onEventsUpdated { events in
            self.events = events
            self.scheduleNotifications()
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
    
    private func notificationsFor(event: Event) -> [UNNotificationRequest] {
        let viewModel = EventViewModel.fromEvent(event)
        let baseDate = viewModel.nextOccurrence
        
        let calendar = Calendar.current
        
        return viewModel.notifications.map { spec in
            let content = UNMutableNotificationContent()
            content.title = spec.title
            content.body = spec.message
            content.sound = UNNotificationSound.default()
            
            let date = calendar.date(byAdding: .day, value: -spec.daysBefore, to: baseDate)!
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: DateComponents(
                    month: calendar.component(.month, from: date),
                    day: calendar.component(.day, from: date),
                    hour: 9
                ),
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: viewModel.event.key ?? "",
                content: content,
                trigger: trigger
            )
            
            return request
        }
    }
    
    private func scheduleNotifications() {
        guard let events = events else { return }
        
        let center = UNUserNotificationCenter.current()
        
        let notifications = events.flatMap { notificationsFor(event: $0) }
        for notification in notifications {
            center.add(notification) { error in
                if error != nil {
                    // Handle any errors
                }
            }
        }
    }
}
