import UIKit
import Foundation

import MessageUI
import ContactsUI

import ConfettiKit

class EventDetailViewController : UITableViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    CNContactPickerDelegate,
    HeroStretchable {
    
    @IBOutlet weak var heroView: HeroView!
    
    var event: EventViewModel! {
        didSet {
            updateDisplay()
        }
    }
    
    enum Action: String {
        case empty
        case call = "Call"
        case message = "Message"
        case faceTime = "FaceTime"
    }
    
    let actions: [Action] = [.empty, .call, .message, .faceTime]
    
    let buttonColors: [UIColor] = [UIColor.white, Colors.purple, Colors.pink, Colors.green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStretchyHero()
        
        // Make buttons respond normally
        tableView.delaysContentTouches = false
        for case let s as UIScrollView in tableView.subviews {
            s.delaysContentTouches = false
        }
        
        styleTransparentNavigationBar()
        updateDisplay()
    }
    
    func updateDisplay() {
        heroView?.event = event
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateStretchyHero()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = actions[indexPath.item]
        let buttonColor = buttonColors[indexPath.item]
        
        switch action {
        case .empty:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "action", for: indexPath) as! EventDetailViewCell
            cell.styleCell(buttonColor, action.rawValue)
            cell.selectionStyle = .none
            cell.tapAction = { _ in self.perform(action: action) }
            return cell
        }
    }
    
    func askToPickContact() {
        let name = event.person.preferredName
        let alert = UIAlertController(
            title: nil,
            message: "No contact info for \(name).",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Pick from contacts", style: .default) { _ in
            self.pickContact()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in return })
        
        present(alert, animated: true)
    }
    
    func pickContact() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // Update the current event with the new contact info
        let newPerson = event.person.with(emails: contact.emails, phones: contact.phones)
        let newEvent = event.event.with(person: newPerson)
        UserViewModel.current.updateEvent(newEvent)
        
        event.event = newEvent
        
        // Now retry the pending action
        guard let action = actionPendingWhileChoosingContact else { return }
        
        picker.dismiss(animated: true) {
            self.actionPendingWhileChoosingContact = nil
            self.perform(action: action)
        }
    }
    
    var actionPendingWhileChoosingContact: Action?
    
    func perform(action: Action) {
        guard let phone = event.person.phones.first else {
            actionPendingWhileChoosingContact = action
            askToPickContact()
            return
        }
        
        switch action {
        case .call:
            guard let url = URL(string: "tel://\(phone.value)") else { break }
            UIApplication.shared.open(url)
        case .faceTime:
            guard let url = URL(string: "facetime://\(phone.value)") else { break }
            UIApplication.shared.open(url)
        case .message:
            let message = MFMessageComposeViewController()
            message.body = "Happy Birthday!"
            message.recipients = [phone.value]
            message.messageComposeDelegate = self
            present(message, animated: true)
        default:
            break
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return calculateContstraints().0
        default:
            return calculateContstraints().1
        }
    }
    
    func calculateContstraints() -> (CGFloat, CGFloat) {
        let tableViewHeight = UIScreen.main.bounds.height / 4
        let buttonsHeight = CGFloat(60)
        
        var headerHeight = CGFloat(10)
        
        // Make sure headerHeight is > 0 and at least 15
        if tableViewHeight - CGFloat(buttonsHeight*2) > 15 {
            headerHeight = tableViewHeight - buttonsHeight*2
        } else {
            headerHeight = 15
        }
        
        return (headerHeight, buttonsHeight)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func pickPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            event.saveImage(image)
            updateDisplay()
        }
    }
    
    
    @IBAction func displayActionSheet(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add Photo", style: .default, handler: { action in
            self.pickPhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Forget", style: .destructive, handler: { action in
            UserViewModel.current.deleteEvent(self.event.event)
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
