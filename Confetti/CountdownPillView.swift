import Foundation
import UIKit

import ConfettiKit

@IBDesignable
class CountdownPillView : UIView {
    
    @IBOutlet var contentView: CountdownPillView!
    
    // Countdown View
    @IBOutlet var stackedCountdownView: RoundedRectangleMask!
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
        Bundle(for: CountdownPillView.self).loadNibNamed("CountdownPillView", owner: self, options: nil)                
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    public func setEvent(_ event: EventViewModel) {
        eventLabel.text = event.title
        countdownMagnitudeLabel.text = String(event.countdownMagnitudeAndUnit.magnitude)
        countdownUnitLabel.text = event.countdownMagnitudeAndUnit.unit
        shortDateLabel.text = event.shortMonthName + " " + String(event.day)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
}
