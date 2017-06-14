import Foundation
import UIKit
import ConfettiKit

@IBDesignable
class HeroView: UIView {
    
    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var pillView: CountdownPillView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
    }
}
