//
//  AddEventViewController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/26/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit

import ConfettiKit

class AddEventViewController : UIViewController {
    
    @IBAction func cancelAddEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        let nav = segue.destination as? UINavigationController
        guard let destination = nav?.topViewController as? ChooseContactViewController else { return }
        
        switch identifier {
        case "addBirthday":
            destination.createEventSpec = CreateBirthdaySpec()
        case "addAnniversary":
            destination.createEventSpec = CreateAnniversarySpec()
        case "addMothersDay":
            destination.createEventSpec = CreateMothersDaySpec()
        case "addFathersDay":
            destination.createEventSpec = CreateFathersDaySpec()
        default:
            return
        }
    }
}
