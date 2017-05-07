import UIKit
import Foundation

import DynamicColor

public class Colors {
    public static let cyan = UIColor(hex: 0x1FD5BE)
    public static let pink = UIColor(hex: 0xFE018A)
    public static let blue = UIColor(hex: 0x039add)
    
    public static let magenta = UIColor(hex: 0xff01d3)
    public static let orange = UIColor(hex: 0xfcab53)
    public static let yellow = UIColor(hex: 0xf0c954)
    public static let mandy = UIColor(hex: 0xed4959)
    public static let mediumAquamarine = UIColor(hex: 0x50d2c2)
    public static let purple = UIColor(hex: 0xbf5fff)
    public static let green = UIColor(hex: 0x2ecc71)
    
    public static let accents = [
        blue,
        orange,
        magenta,
        yellow,
        mandy,
        mediumAquamarine,
        purple,
        green,
    ]
    
    public static func accentFor<H: Hashable>(_ object: H) -> UIColor {
        let hash = abs(object.hashValue)
        return accents[hash % accents.count]
    }
}
