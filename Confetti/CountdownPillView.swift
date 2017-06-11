import Foundation
import UIKit

import ConfettiKit

@IBDesignable
class CountdownPillView : UIView {
    
    @IBOutlet var contentView: CountdownPillView!
    
    // Countdown View
    @IBOutlet var stackedCountdownView: StackedCountdownLabel!
    @IBOutlet var countdownMagnitudeLabel: UILabel!
    @IBOutlet var countdownUnitLabel: UILabel!
    
    // Labels
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
        countdownMagnitudeLabel.text = String(event.countdownMagnitudeAndUnit.magnitude)
        countdownUnitLabel.text = event.countdownMagnitudeAndUnit.unit
        shortDateLabel.text = event.shortMonthName + " " + String(event.day)
    }
}
