import Foundation

import UIKit

import ConfettiKit

class EventDetailViewCell: UITableViewCell {
    
    @IBOutlet var actionButton: RoundRectangleButton!
    
    func styleCell(_ color: UIColor, _ action: String) {
        actionButton.setTitle(action, for: .normal)
        actionButton.tintColor = color
    }
}
