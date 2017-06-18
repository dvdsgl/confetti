import Foundation
import UIKit

import ConfettiKit

class ChooseOccasionViewController: UIViewController {
    
    @IBOutlet var translucentOverlay: UIView!
    @IBOutlet var buttonsDrawer: UIView!
    
    @IBOutlet weak var buttonDrawerOpenConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonDrawerClosedConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        translucentOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(closeTapped(_:))))
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        close {
            self.dismiss(animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        open()
    }
    
    func open() {
        UIView.animate(withDuration: 0.4) {
            self.translucentOverlay.backgroundColor = UIColor(white: 0, alpha: 0.3)
        }
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 15,
                       options: [],
                       animations: {
            self.view.removeConstraint(self.buttonDrawerClosedConstraint)
            self.view.addConstraint(self.buttonDrawerOpenConstraint)
            self.view.layoutIfNeeded()
        })
    }
    
    func close(_ completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: {
            self.translucentOverlay.backgroundColor = .clear
        })
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.addConstraint(self.buttonDrawerClosedConstraint)
            self.view.removeConstraint(self.buttonDrawerOpenConstraint)
            self.view.layoutIfNeeded()
        }, completion: { _ in completion() })
    }
    
    let createEventSpecForSegue: [String: () -> CreateEventSpec] = [
        "addBirthday": { CreateBirthdaySpec() },
        "addAnniversary": { CreateAnniversarySpec() },
        "addMothersDay": { CreateMothersDaySpec() },
        "addFathersDay": { CreateFathersDaySpec() }
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        let nav = segue.destination as? UINavigationController
        guard let destination = nav?.topViewController as? ChooseContactViewController else { return }
        
        destination.createEventSpec = createEventSpecForSegue[identifier]?()
    }
}
