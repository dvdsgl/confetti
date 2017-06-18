import Foundation
import UIKit

func viewController<T: UIViewController>(_ id: String) -> T? {
    let board = UIStoryboard(name: "Main", bundle: nil)
    return board.instantiateViewController(withIdentifier: id) as? T
}
