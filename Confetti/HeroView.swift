import Foundation
import UIKit
import ConfettiKit
import FirebaseAuth

@IBDesignable
class HeroView: UIView {
    
    @IBOutlet weak var defaultImage: UIImageView!
    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var pillView: CountdownPillView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var confettiMachine: ConfettiMachineView!
    
    var topShade: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    enum RunMode {
        case event(EventViewModel), profile
    }
    
    var runMode: RunMode = .profile {
        didSet {
            switch runMode {
            case let .event(event):
                buildEvent(event: event)
            case .profile:
                buildProfilePage()
            }
        }
    }
    
    func buildEvent(event: EventViewModel) {
        event.displayImage(in: heroImage)
        pillView.event = event
        
        contentView.backgroundColor = Colors.accentFor(event.person.fullName)
        
        let hasImage = event.person.photoUUID != nil
        topShade.isHidden = !hasImage
        defaultImage.isHidden = hasImage
        heroImage.isHidden = !hasImage
        
        confettiMachine.isRunning = event.daysAway == 0
    }
    
    func buildProfilePage() {
        pillView.isHidden = true
        
        let user = Auth.auth().currentUser
        if let user = user {
            let hasImage = user.photoURL != nil
            topShade.isHidden = !hasImage
            defaultImage.isHidden = hasImage
            heroImage.isHidden = !hasImage
            
            UserViewModel.current.displayImage(in: heroImage)
        }
    }
    
    func commonInit() {
        Bundle(for: HeroView.self).loadNibNamed("HeroView", owner: self, options: nil)
        
        topShade = CAGradientLayer()
        topShade.colors = [
            UIColor(white: 0, alpha: 0.5),
            UIColor(white: 0, alpha: 0)
        ].map { $0.cgColor }
        
        topShade.locations = [0, 1]
        heroImage.layer.addSublayer(topShade)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topShade.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 70)
    }
}
