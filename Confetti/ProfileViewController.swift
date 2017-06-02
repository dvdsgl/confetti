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
import FirebaseAuth
import Firebase

import MobileCenterCrashes

class ProfileViewController : UITableViewController {
    
    @IBOutlet var profileTableView: UITableView!

    @IBOutlet weak var profileImage: FRStretchImageView!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    fileprivate var source = [
        "Name",
        "Crash the app!",
        "Logout"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Profile"
        
        // Setting FRStretchImageView
        profileImage.stretchHeightWhenPulledBy(scrollView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in            
            // Set user's facebook photo as the hero image
            if let facebookUserId = Auth.auth().currentUser?.providerData.first?.uid {
                let photoUrl = URL(string: "https://graph.facebook.com/" + facebookUserId + "/picture?height=500")
                self.profileImage.sd_setImage(with: photoUrl)
            } else {
                self.profileImage.image = #imageLiteral(resourceName: "stu")
            }
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) 
        cell.textLabel?.text = source[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch source[indexPath.row] {
        case "Logout":
            logOut()
            return
        case "Crash the app!":
            MSCrashes.generateTestCrash()
        default:
            return
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
}
