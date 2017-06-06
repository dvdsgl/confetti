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
    
    func notificationFor(event: Event) -> UNNotificationRequest {
        let viewModel = EventViewModel.fromEvent(event)
        
        let content = UNMutableNotificationContent()
        content.title = viewModel.person.firstName
        content.body = viewModel.description
        content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(month: viewModel.month, day: viewModel.day, hour: 9),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: viewModel.event.key ?? "",
            content: content,
            trigger: trigger
        )
        
        return request
    }
    
    func scheduleNotifications(event: Event) {
        let notification = notificationFor(event: event)
        let center = UNUserNotificationCenter.current()
        center.add(notification) { error in
            if error != nil {
                // Handle any errors
            }
        }
    }
}
