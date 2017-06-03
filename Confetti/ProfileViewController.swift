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

import UserNotifications

class ProfileViewController : UITableViewController {
    
    @IBOutlet var profileTableView: UITableView!

    @IBOutlet weak var profileImage: FRStretchImageView!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    fileprivate var source = [
        "Name",
        "Crash the app!",
        "Logout",
        "Test Notification"
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
            return
        case "Test Notification":
            testNotification()
            return
        default:
            return
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    // Sends test notification 5 seconds after tapping
    func testNotification() {
        // Set up content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if error != nil {
                // Handle any errors
            }
        }
    }    
}
