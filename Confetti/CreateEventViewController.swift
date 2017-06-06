import UIKit
import Foundation

import ConfettiKit

import Firebase

import Contacts

import SDWebImage
import AvatarImageView

import UserNotifications

class CreateEventViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    @IBOutlet var photoView: AvatarImageView!
    
    @IBOutlet var navBarItem: UINavigationItem!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var createEventSpec: CreateEventSpec!
    
    var contact: CNContact?
    var photoUrl: URL?
    
    struct AvatarConfig: AvatarImageViewConfiguration {
        var shape: Shape = .circle
    }
    
    struct AvatarData: AvatarImageViewDataSource {
        let name: String
        let avatar: UIImage?
        
        var bgColor: UIColor? {
            return Colors.accentFor(avatarId)
        }
        
        init(contact: CNContact) {
            if let data = contact.imageData {
                avatar = UIImage(data: data)
            } else {
                avatar = nil
            }
            name = CNContactFormatter.string(from: contact, style: .fullName)!
        }
    }
    
    @IBAction func updateDatePicker(_ sender: Any) {
        let birthday = datePicker.date
        let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year!
        let nextAge = NSNumber(integerLiteral: age + 1)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let nextAgeFormatted = formatter.string(from: nextAge)
        
        navBarItem.title = (contact?.givenName)! + "'s " + nextAgeFormatted! + " birthday"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let contact = contact {
            navBarItem.title = contact.givenName + "'s Birthday"
            
            photoView.configuration = AvatarConfig()
            photoView.dataSource = AvatarData(contact: contact)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let firstName = contact?.givenName else { return }
        
        let birthday = datePicker.date
        let month = datePicker.calendar.component(.month, from: birthday)
        let day = datePicker.calendar.component(.day, from: birthday)
        let year = datePicker.calendar.component(.year, from: birthday)
        
        let person = Person(firstName, photoUrl: photoUrl?.absoluteString)
        let event = createEventSpec.createEvent(person: person, month: month, day: day, year: year)
        
        UserViewModel.current.addEvent(event)
        
        scheduleNotifications(event: event)
        
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let data = UIImageJPEGRepresentation(pickedImage, 0.5)!
            
            let storage = Storage.storage()
            let imagesNode = storage.reference().child("images")
            
            let uuid = UUID.init()
            let imageRef = imagesNode.child("\(uuid.uuidString).jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else { return }
                self.photoUrl = metadata.downloadURL()
            }
        }
        
        dismiss(animated: true)
    }
    
    func scheduleNotifications(event: Event) {
        let eventViewModel = EventViewModel.fromEvent(event)
        
        //TODO: Handle mother's/father's day
        // Set up content for push notification
        let occasion = createEventSpec.description
        let firstName = eventViewModel.person.firstName
        let message = "It's \(firstName)'s \(occasion!). Get in touch!"
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hi!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Configure the trigger on the day of the event at 9 AM
        var dateInfo = DateComponents()
        dateInfo.minute = 0
        dateInfo.hour = 9
        dateInfo.day = eventViewModel.day
        dateInfo.month = eventViewModel.month
        
        // 5 second delay test trigger
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //Actual date trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        let request = UNNotificationRequest(identifier: "EventToday", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if error != nil {
                // Handle any errors
            }
        }
    }
}
