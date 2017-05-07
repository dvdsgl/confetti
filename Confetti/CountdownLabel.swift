import UIKit
import Foundation

import ConfettiKit

@IBDesignable
class CountdownLabel: UILabel {
    let padding = CGSize(width: 10, height: 6)
    
    let backgroundColorSoon = Colors.pink
    let backgroundColorLater = Colors.lightGray
    
    var event: EventViewModel? {
        didSet {
            guard let event = event else { return }
            backgroundColor = event.isSoon ? backgroundColorSoon : backgroundColorLater
            text = event.countdown
            sizeToFit()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.width, height: size.height + padding.height)
    }
    
}
