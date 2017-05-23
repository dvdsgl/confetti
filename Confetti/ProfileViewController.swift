//
//  ProfileViewController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/22/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit
import ConfettiKit
import FRStretchImageView

class ProfileViewController : UITableViewController {
    
    @IBOutlet var profileTableView: UITableView!

    @IBOutlet weak var profileImage: FRStretchImageView!
    
    fileprivate var source : [String] = [
        "Name",
        "Birthday"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Profile"
        
        // Setting FRStretchImageView
        profileImage.stretchHeightWhenPulledBy(scrollView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) 
        cell.textLabel?.text = source[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
}
