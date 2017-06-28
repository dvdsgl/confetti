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
    
    let buttonColors: [UIColor] = [UIColor.white, Colors.purple, Colors.pink, Colors.green]
    
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
            cell.tapAction = { [weak self] (cell) in
                print(action)}
            return cell
        }
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
        let buttonsHeight = CGFloat(70)
        
        var headerHeight = CGFloat(10)
        
        //Make sure headerHeight is > 0 so we don't crash
        if tableViewHeight - CGFloat(buttonsHeight*2) > 0 {
            headerHeight = tableViewHeight - buttonsHeight*2
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
