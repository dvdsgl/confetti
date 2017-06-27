import UIKit
import Foundation

import ConfettiKit

class EventDetailViewController : UITableViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStretchyHero()
        
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
        
        switch action {
        case .empty:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.lightGray
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "action", for: indexPath)
            cell.textLabel?.text = action.rawValue
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 30
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
