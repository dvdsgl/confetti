import Foundation
import UIKit
import ConfettiKit

@IBDesignable
class HeroView: UIView {
    
    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var pillView: CountdownPillView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var confettiMachine: ConfettiMachineView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle(for: HeroView.self).loadNibNamed("HeroView", owner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    var event: EventViewModel! {
         didSet {
            event.displayImage(in: heroImage)
            pillView.event = event
            
            confettiMachine.isRunning = event.daysAway == 0
        }
    }
}
