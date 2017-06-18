import UIKit
import Foundation

import ConfettiKit

import Firebase

import Contacts

import SDWebImage
import AvatarImageView

extension Contact {
    func with(image: UIImage? = nil) -> Contact {
        var imageSource: ImageSource?
        if let data = image?.sd_imageData() {
            imageSource = .data(data)
        }
        
        return ManualContact(
            name,
            nick: nick,
            imageSource: imageSource
        )
    }
    
    var person: Person {
        return Person(name: name, nickname: nick)
    }
}

class CreateEventViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    @IBOutlet var photoView: AvatarImageView!
    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet var datePicker: UIDatePicker!
    
    var createEventSpec: CreateEventSpec!    
    var contact: Contact!
    
    struct AvatarConfig: AvatarImageViewConfiguration {
        var shape: Shape = .circle
    }
    
    struct AvatarData: AvatarImageViewDataSource {
        let name: String
        let avatar: UIImage?
        
        var bgColor: UIColor? {
            return Colors.accentFor(avatarId)
        }
        
        init(contact: Contact) {
            avatar = contact.image
            name = contact.name
        }
    }
    
    override func viewDidLoad() {
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(choosePhoto(_:))))
        photoView.configuration = AvatarConfig()
    }
    
    func updateDisplay() {
        photoView.dataSource = AvatarData(contact: contact)
        
        let date = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        let event = createEventSpec.createEvent(person: contact.person, month: date.month!, day: date.day!, year: date.year)
        let viewModel = EventViewModel.fromEvent(event)
        navBarItem.title = viewModel.title
    }
    
    @IBAction func updateDatePicker(_ sender: Any) {
        updateDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDisplay()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        let event = createEventSpec.createEvent(
            person: contact.person,
            month: date.month!,
            day: date.day!,
            year: date.year
        )
        
        UserViewModel.current.addEvent(event)
        
        let viewModel = EventViewModel.fromEvent(event)
        if let imageData = contact.image?.sd_imageData() {
            viewModel.saveImage(data: imageData)
        }
        
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
        dismiss(animated: true)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            contact = contact.with(image: image)
            updateDisplay()
        }
    }
}
