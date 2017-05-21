//
//  CustomTabBarController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/21/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit

import ConfettiKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        let butt = UIView(frame: CGRect(x: 0, y: -20, width: 50, height: 50))
        
        butt.backgroundColor = Colors.pink
        butt.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(butt)

        view.addConstraints([
            NSLayoutConstraint(item: butt, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: butt, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: butt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: butt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
        ])
        
        view.bringSubview(toFront: butt)
    }
}
