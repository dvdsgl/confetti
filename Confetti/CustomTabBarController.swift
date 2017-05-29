//
//  CustomTabBarController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/23/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit

import ConfettiKit

class CustomTabBarController: UITabBarController {
    
    let size = CGFloat(54)
    
    @IBOutlet var addEventButton: UIButton!
    
//    @IBAction func addEvent(_ sender: Any) {
//        performSegue(withIdentifier: "newEvent", sender: self)
//    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addEventButton)
        
        view.addConstraints([
            NSLayoutConstraint(item: addEventButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: addEventButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -4),
            NSLayoutConstraint(item: addEventButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size),
            NSLayoutConstraint(item: addEventButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size),
            ])
    }
}
