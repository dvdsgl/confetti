import Foundation
import UIKit

import ConfettiKit

@IBDesignable
class CountdownPillView : UIView {
    
    @IBOutlet var contentView: CountdownPillView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CountdownPillView", owner: self, options: nil)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
}
