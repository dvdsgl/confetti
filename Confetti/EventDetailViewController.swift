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
        case call = "Call"
        case message = "Message"
        case faceTime = "FaceTime"
    }
    
    let actions: [Action] = [.call, .message, .faceTime]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStretchyHero()
        
        updateDisplay()
    }
    
    func updateDisplay() {
        if let imageView = heroView?.heroImage {
            event.displayImage(in: imageView)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateStretchyHero()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "action", for: indexPath)
        
        let action = actions[indexPath.item]
        cell.textLabel?.text = action.rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func pickPhoto(_ sender: Any) {
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
}
