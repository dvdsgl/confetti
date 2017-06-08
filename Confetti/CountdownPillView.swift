import Foundation
import UIKit

@IBDesignable
class CountdownPillView : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
}
