import Foundation

import UIKit

import ConfettiKit

class EventDetailViewCell: UITableViewCell {
    
    @IBOutlet var actionButton: RoundRectangleButton!
    
    func setAction(_ action: String) {
        actionButton.setTitle(action, for: .normal)
    }
    
    func setColor(_ color: UIColor) {
        actionButton.tintColor = color
    }
}
