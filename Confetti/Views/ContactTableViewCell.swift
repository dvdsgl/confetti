import UIKit
import Foundation

import ConfettiKit

import AvatarImageView
import SDWebImage


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
            
            if let imageData = contact.imageData {
                photoView.image = UIImage(data: imageData)
            }
        }
    }
}
