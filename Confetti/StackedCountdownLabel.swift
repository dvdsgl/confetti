import Foundation
import UIKit

class StackedCountdownLabel : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
}
