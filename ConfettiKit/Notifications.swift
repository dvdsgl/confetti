import Foundation

public struct NotificationRegistration {
    let removeObserver: () -> ()
}

public struct Notifications {
    static var center: NotificationCenter {
        return NotificationCenter.default
    }
    
    public struct EventsChanged {
        private static let name = Notification.Name(rawValue: "EventsChangedNotification")
        
        private static let eventsKey = "events"
        
        public static func subscribe(_ onEventsUpdated: @escaping ([Event]) -> ()) -> NotificationRegistration {
            let observer = center.addObserver(forName: name, object: nil, queue: nil, using: { note in
                let events = note.userInfo![eventsKey] as! [Event]
                onEventsUpdated(events)
            })
            
            return NotificationRegistration {
                center.removeObserver(observer)
            }
        }
        
        static func create(sender: Any, events: [Event]) -> Notification {
            return Notification(
                name: name,
                object: sender,
                userInfo: [
                    eventsKey: events
                ])
        }
        
        public static func post(sender: Any, events: [Event]) {
            center.post(create(sender: sender, events: events))
        }
    }
}
