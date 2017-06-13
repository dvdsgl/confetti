//
//  DetailViewController.swift
//  Confetti
//
//  Created by David Siegel on 5/6/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import UIKit
import ConfettiKit

import SDWebImage
import AvatarImageView

fileprivate struct AvatarConfig: AvatarImageViewConfiguration {
    var shape: Shape = .square
}

fileprivate struct AvatarData: AvatarImageViewDataSource {
    var name: String
    
    var bgColor: UIColor? {
        return Colors.accentFor(avatarId)
    }
    
    init(name: String) {
        self.name = name
    }
}

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: AvatarImageView!
    
    var detailItem: EventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.configuration = AvatarConfig()
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func update() {
        if let event = detailItem?.event {
            imageView.dataSource = AvatarData(name: event.person.firstName)
            detailItem?.displayImage(in: imageView)
        }
    }
}

