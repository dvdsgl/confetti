import Foundation
import UIKit

import ConfettiKit

class AddEventViewController : UIViewController {
    
    @IBOutlet var translucentOverlay: UIView!
    
    @IBOutlet var buttonsDrawer: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        view.bringSubview(toFront: buttonsDrawer)
        
        UIView.animate(withDuration: 1.0,
                       animations: {
                        self.translucentOverlay.backgroundColor = UIColor.white },
                       completion: nil)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 15,
                       options: [],
                       animations: {
                        self.buttonsDrawer?.center = CGPoint(
                            x: (self.buttonsDrawer?.center.x)!,
                            y: self.buttonsDrawer.frame.height) },
                       completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        let nav = segue.destination as? UINavigationController
        guard let destination = nav?.topViewController as? ChooseContactViewController else { return }
        
        switch identifier {
        case "addBirthday":
            destination.createEventSpec = CreateBirthdaySpec()
            destination.createEventSpec.title = "Whose Birthday?"
        case "addAnniversary":
            destination.createEventSpec = CreateAnniversarySpec()
            destination.createEventSpec.title = "Whose Anniversary?"
        case "addMothersDay":
            destination.createEventSpec = CreateMothersDaySpec()
            destination.createEventSpec.title = "Who's Mom?"
        case "addFathersDay":
            destination.createEventSpec = CreateFathersDaySpec()
            destination.createEventSpec.title = "Who's Dad?"
        default:
            return
        }
    }
}
