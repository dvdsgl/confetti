import Foundation
import UserNotifications

import ConfettiKit

import Firebase
import FirebasePerformance

import CodableFirebase

// TODO Figure out how to get this into ConfettiKit
// I couldn't figure out how to link Firebase twice
public class UserViewModel {
    
    public static let current = UserViewModel()
    
    var db: DatabaseReference!
    
    private var userAuth: User {
        return Auth.auth().currentUser!
    }
    
    var isAnonymous: Bool {
        return userAuth.isAnonymous
    }
    
    var userNode: DatabaseReference {
        return db.child("users").child(userAuth.uid)
    }
    
    var eventsNode: DatabaseReference {
        return userNode.child("events")
    }
    
    public private(set) var events: [Event]?
    
    var firebaseObservers = [UInt]()
    
    private func endPreviousSessionIfAny() {
        firebaseObservers.forEach { db.removeObserver(withHandle: $0) }
        firebaseObservers = []
        events = nil
    }
    
    func beginSession() {
        endPreviousSessionIfAny()
        
        var userData = [AnyHashable: Any]()
        if let email = userAuth.email {
            userData["email"] = email
        }
        userNode.updateChildValues(userData)
        
        firebaseObservers.append(onEventsUpdated { events in
            self.events = events
            Notifications.EventsChanged.post(sender: self, data: events)
        })
    }
    
    func logout() {
        if AppDelegate.shared.runMode == .testRun && userAuth.isAnonymous {
            userNode.removeValue()
            userAuth.delete()
        }
        
        endPreviousSessionIfAny()
        
        try! Auth.auth().signOut()
    }
    
    private init() {
        db = Database.database().reference()
    }
    
    func onEventsChanged(_ onEventsUpdated: @escaping ([Event]) -> ()) -> NotificationRegistration {
        if let events = events {
            onEventsUpdated(events)
        }
        return Notifications.EventsChanged.subscribe(onEventsUpdated)
    }

    private func onEventsUpdated(_ success: @escaping ([Event]) -> ()) -> UInt {
        let trace = Performance.startTrace(name: "UserViewModel.getEvents")
 
        return eventsNode.observe(.value, with: { snapshot in
            trace?.stop()
            
            var events = [Event]()
            for eventNode in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = eventNode.value {
                    if let event = try? FirebaseDecoder().decode(Event.self, from: value) {
                        events.append(event.with(key: eventNode.key))
                    }
                }
            }
            
            success(events)
        })
    }
    
    public func addEvent(_ event: Event) -> Event {
        let child = eventsNode.childByAutoId()
        let keyedEvent = event.with(key: child.key)

        child.setValue(try! FirebaseEncoder().encode(keyedEvent))
        
        return keyedEvent
    }
    
    public func deleteEvent(_ event: Event) {
        guard let key = event.key else { return }
        eventsNode.child(key).removeValue()
    }
    
    func updateEvent(_ event: Event) {
        guard let key = event.key else { return }
        
        let data = try! FirebaseEncoder().encode(event)
        eventsNode.child(key).setValue(data)
    }
    public var profilePhotoUUID: UUID?
    
    fileprivate var imagesNode: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    var imageReference : StorageReference? {
        guard let uuid = profilePhotoUUID else { return nil }
        return imagesNode.child(uuid.uuidString)
    }
    
    func saveImage(url: URL) {
        let uuid = UUID() // we always allocate a new image, rather than replacing
        let imageRef = imagesNode.child(uuid.uuidString)
        
        profilePhotoUUID = uuid
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: url)
            
            DispatchQueue.global(qos: .background).async {
                let _ = imageRef.putData(data!,
                                         metadata: metadata,
                                         completion: { (metadata, error) in
                                            if let _ = error {
                                                print("Error uploading image:" + String(describing: error))
                                            } else {
                                                return
                                            }
                })
            }
        }
    }
    
    func displayImage(in view: UIImageView) {
        if let imageRef = imageReference {
            view.sd_setImage(with: imageRef)
        }
    }
}
