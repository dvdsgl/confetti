import Foundation
import UIKit

import ConfettiKit

@IBDesignable
class CountdownPillView : UIView {
    
    @IBOutlet var contentView: CountdownPillView!
    @IBOutlet var stackedCountdownView: StackedCountdownLabel!
    @IBOutlet var countdownLabel: UILabel!
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var shortDateLabel: UILabel!
    
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
    
    public func setEvent(_ event: EventViewModel) {
        eventLabel.text = event.title
        countdownLabel.text = event.countdown
        shortDateLabel.text = String(describing: event.nextOccurrence)
    }
}
