import UIKit
import Foundation

import ConfettiKit

import Firebase

import Contacts

class CreateEventViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    var photoUrl: URL?
    
    @IBAction func createEvent(_ sender: Any) {
        guard let firstName = firstNameField.text else { return }
        guard let month = Int(monthField.text ?? "") else { return }
        guard let day = Int(dayField.text ?? "") else { return }
        let year = Int(yearField.text ?? "")
        
        let person = Person(firstName, photoUrl: photoUrl?.absoluteString)
        let occasion = Occasion.birthday(month: month, day: day, year: year)
        let event = Event(person: person, occasion: occasion)
        
        UserViewModel.current.addEvent(event)
        
        dismiss(animated: true)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // Constants for Storyboard/ViewControllers.
    static let storyboardName = "Main"
    static let viewControllerIdentifier = "CreateEventViewController"
    
    var contact = CNContact()
    
    class func createEventViewController(_ contact: CNContact) -> CreateEventViewController {
        let storyboard = UIStoryboard(name: CreateEventViewController.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: CreateEventViewController.viewControllerIdentifier) as! CreateEventViewController
        
        viewController.contact = contact
        
        return viewController
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
