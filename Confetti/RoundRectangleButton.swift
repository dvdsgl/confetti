//
//  RoundRectangleButton.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/7/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import UIKit
import Foundation

import ConfettiKit

@IBDesignable
class RoundRectangleButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 2
        layer.masksToBounds = true
        tintColor = Colors.pink
    }
    
    @IBInspectable
    public override var tintColor: UIColor! {
        didSet {
            setTitleColor(tintColor, for: .normal)
            layer.borderColor = tintColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
}
