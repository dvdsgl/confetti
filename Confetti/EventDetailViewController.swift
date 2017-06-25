import UIKit
import Foundation

import ConfettiKit

class EventDetailViewController : UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var heroView: HeroView!
    @IBOutlet var heroViewHeightConstraint: NSLayoutConstraint!
    
    var event: EventViewModel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    enum Action: String {
        case call = "Call"
        case message = "Message"
        case faceTime = "FaceTime"
    }
    
    let actions: [Action] = [.call, .message, .faceTime]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        
        heroViewHeightConstraint.constant = UIScreen.main.bounds.height / 2
        
        styleTransparentNavigationBar()
        updateDisplay()
    }
    
    func updateDisplay() {
        heroView?.event = event
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        heroViewHeightConstraint.constant = -self.scrollView.contentOffset.y / 2
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
