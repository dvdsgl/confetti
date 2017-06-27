import Foundation

import UIKit

class EventDetailViewCell: UITableViewCell {
    
    @IBOutlet var actionButton: RoundRectangleButton!
    
    func setAction(_ action: String) {
        actionButton.setTitle(action, for: .normal)
    }
}
