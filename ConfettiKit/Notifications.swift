import Foundation

public struct NotificationRegistration {
    public let removeObserver: () -> ()
}

public protocol NotificationProtocol {
    associatedtype TData
    static var name: String { get }
}

extension NotificationProtocol {
    private static var center: NotificationCenter {
        return NotificationCenter.default
    }
    
    private static var noteName: Notification.Name {
        return Notification.Name(rawValue: name)
    }
    
    public static func subscribe(_ receive: @escaping (TData) -> ()) -> NotificationRegistration {
        let observer = center.addObserver(forName: noteName, object: nil, queue: nil, using: { note in
            let data = note.userInfo!["data"] as! TData
            receive(data)
        })
        
        return NotificationRegistration {
            center.removeObserver(observer)
        }
    }
    
    public static func post(sender: Any, data: TData) {
        let note = Notification(
            name: noteName,
            object: sender,
            userInfo: ["data": data]
        )
        center.post(note)
    }
}

public struct Notifications {
    public struct EventsChanged: NotificationProtocol {
        public typealias TData = [Event]
        public static let name = "EventsChangedNotification"
    }
    
    public struct EventOpened: NotificationProtocol {
        public typealias TData = String
        public static let name = "EventOpened"
    }
}
