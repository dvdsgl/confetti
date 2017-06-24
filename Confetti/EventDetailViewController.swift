import UIKit
import Foundation

import ConfettiKit

protocol HeroStretchableScrollView {
    var scrollView: UIScrollView! { get }
    var heroView: HeroView! { get }
}

extension HeroStretchableScrollView {
    private var heroViewHeight: CGFloat {
        return UIScreen.main.bounds.height / 2
    }
    
    // Call this in viewDidLoad
    func setupStretchyHero() {
        scrollView.addSubview(heroView)
        scrollView.contentInset = UIEdgeInsets(top: heroViewHeight, left: 0, bottom: 0, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -heroViewHeight)
    }
    
    // Call this in scrollViewDidScroll
    func updateStretchyHero() {
        var headerRect = CGRect(x: 0, y: -heroViewHeight, width: scrollView.bounds.width, height: heroViewHeight)
        if scrollView.contentOffset.y < -heroViewHeight {
            headerRect.origin.y = scrollView.contentOffset.y
            headerRect.size.height = -scrollView.contentOffset.y
        }
        heroView.frame = headerRect
    }
}

class EventDetailViewController : UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UIScrollViewDelegate, HeroStretchableScrollView {
    
    @IBOutlet weak var heroView: HeroView!
    
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
        
        self.scrollView.delegate = self
        
        styleTransparentNavigationBar()
        setupStretchyHero()
        updateDisplay()
    }
    
    func updateDisplay() {
        heroView?.event = event
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        print(self.scrollView.contentOffset.y)
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
