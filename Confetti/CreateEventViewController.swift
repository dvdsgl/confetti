import UIKit
import Foundation

import ConfettiKit

class CreateEventViewController: UIViewController {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    @IBAction func createEvent(_ sender: Any) {
        guard let firstName = firstNameField.text else { return }
        guard let month = Int(monthField.text ?? "") else { return }
        guard let day = Int(dayField.text ?? "") else { return }
        let year = Int(yearField.text ?? "")
        
        let person = Person(firstName)
        let occasion = Occasion.birthday(month: month, day: day, year: year)
        let event = Event(person: person, occasion: occasion)
        
        UserViewModel.current.addEvent(event)
        
        dismiss(animated: true)
    }
}
