import Foundation
import UIKit

import ConfettiKit

@IBDesignable
class CountdownPillView : UIView {
    
    @IBOutlet var contentView: CountdownPillView!
    @IBOutlet var stackedCountdownView: UIView!
    
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
        
        self.addSubview(contentView)
        contentView.layer.cornerRadius = self.bounds.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        stackedCountdownView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    override func didAddSubview(_ subview: UIView) {
        stackedCountdownView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
