import UIKit
import Foundation

import ConfettiKit

import AvatarImageView
import SDWebImage

extension UIImageView {
    func displayContact(_ contact: Contact) {
        if let source = contact.imageSource {
            switch source {
            case let .data(data):
                self.image = UIImage(data: data)
            case let .url(url):
                self.sd_setImage(with: URL(string: url)!)
            }
        }
    }
}

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: AvatarImageView!
    @IBOutlet weak var countdown: CountdownLabel!
    
    public static let defaultHeight: CGFloat = 70
    
    struct AvatarConfig: AvatarImageViewConfiguration {
        var shape: Shape = .circle
    }
    
    struct AvatarData: AvatarImageViewDataSource {
        var name: String
        
        var bgColor: UIColor? {
            return Colors.accentFor(avatarId)
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    override func awakeFromNib() {
        photoView.layer.cornerRadius = photoView.bounds.width / 2
    }
    
    var contact: Contact! {
        didSet {
            nameLabel.text = contact.fullName
            
            photoView.configuration = AvatarConfig()
            photoView.dataSource = AvatarData(name: contact.fullName)
            photoView.displayContact(contact)
        }
    }
}
