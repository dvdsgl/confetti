import Foundation

import UIKit

import ConfettiKit

class EventDetailViewCell: UITableViewCell {
    
    @IBOutlet var actionButton: RoundRectangleButton!
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    func styleCell(_ color: UIColor, _ action: String) {
        actionButton.setTitle(action, for: .normal)
        actionButton.tintColor = color
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
         tapAction?(self)
    }        
}
