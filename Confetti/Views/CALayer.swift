import UIKit
import Foundation

extension CALayer {
    var shadowColorIB: UIColor? {
        set { shadowColor = newValue?.cgColor }
        get { return shadowColor.map { UIColor(cgColor: $0) } }
    }
}
