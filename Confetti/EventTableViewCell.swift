import UIKit
import Foundation

import ConfettiKit

import AvatarImageView
import SDWebImage

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: AvatarImageView!
    @IBOutlet weak var countdown: CountdownLabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    public static let defaultHeight: CGFloat = 70;

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

    public func setEvent(_ event: EventViewModel) {
        nameLabel.text = event.person.name
        descriptionLabel.text = event.description

        photoView.configuration = AvatarConfig()
        photoView.dataSource = AvatarData(name: event.person.name)

        event.displayImage(in: photoView)
        
        countdown.event = event
    }
}
