import Foundation
import UIKit

class RoundedRectangleMask : UIView {
    /* TODO: Get rid of this class. This exists because of some autolayout issues in CountdownPillView. For some reason if you call layoutSubviews in the class itself, it skews the circle shape of the countdown view. It looks like the the auto resizing gets done *after* layoutSubviews has been called in CountdownPillView, resulting in a distorted circle. */
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
}
