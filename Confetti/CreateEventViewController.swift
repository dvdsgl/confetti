import UIKit
import Foundation

import ConfettiKit

import Firebase

import Contacts

import SDWebImage
import AvatarImageView


class CreateEventViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    @IBOutlet var photoView: AvatarImageView!
    
    @IBOutlet var navBarItem: UINavigationItem!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var contact: CNContact?
    var photoUrl: URL?
    
    struct AvatarConfig: AvatarImageViewConfiguration {
        var shape: Shape = .circle
    }
    
    struct AvatarData: AvatarImageViewDataSource {
        var name: String
        
        var bgColor: UIColor? {
            return Colors.accentFor(avatarId)
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let contact = contact {
            navBarItem.title = contact.givenName + "'s Birthday"
            
            photoView.configuration = AvatarConfig()
            photoView.dataSource = AvatarData(name: contact.givenName)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let firstName = contact?.givenName else { return }
        
        let birthday = datePicker.date
        let month = datePicker.calendar.component(.month, from: birthday)
        let day = datePicker.calendar.component(.day, from: birthday)
        let year = datePicker.calendar.component(.year, from: birthday)
        
        let person = Person(firstName, photoUrl: photoUrl?.absoluteString)
        let occasion = Occasion.birthday(month: month, day: day, year: year)
        let event = Event(person: person, occasion: occasion)
        
        UserViewModel.current.addEvent(event)
        
        performSegue(withIdentifier: "unwindToMain", sender: self)
//        dismiss(animated: true)
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
}
