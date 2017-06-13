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

class DetailViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: AvatarImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var detailItem: EventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get rid of nav bar shadow for a nice, continuous look
        if let bar = navigationController?.navigationBar {
            bar.shadowImage = UIImage()
            bar.setBackgroundImage(UIImage(), for: .default)
            bar.isTranslucent = true
            
            scrollView.contentOffset = CGPoint(x: 0, y: -heroHeight)
        }
        
        imageView.configuration = AvatarConfig()
        update()
    }
    
    var heroHeight: CGFloat {
        let barHeight = navigationController?.navigationBar.frame.height ?? 0
        let halfScreenHeight = UIScreen.main.bounds.height / 2
        let statusBarHeight = UIApplication.shared.statusBarFrame.maxY
        return halfScreenHeight - statusBarHeight - barHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func pickPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            detailItem?.saveImage(image)
            update()
        }
    }
    
    func update() {
        if let event = detailItem?.event {
            imageView.dataSource = AvatarData(name: event.person.firstName)
            detailItem?.displayImage(in: imageView)
        }
    }
}

