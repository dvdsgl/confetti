import Foundation
import UIKit

import ConfettiKit

@IBDesignable
class CountdownPillView : UIView {
    
    @IBOutlet weak var pillTitleLabel: UILabel!
    @IBOutlet weak var pillShortDateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
    
    public func setEvent(_ event: EventViewModel) {
        pillTitleLabel.text = event.title
    }
}
