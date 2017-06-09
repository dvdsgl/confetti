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
    
    enum Action: String {
        case name = "Name"
        case logout = "Logout"
        case crash = "Crash the app!"
        case testNotification = "Send test notification"
        case showVersion = "showVersion"
    }
    
    let source: [Action] = [.name, .logout, .crash, .testNotification, .showVersion]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.stretchHeightWhenPulledBy(scrollView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // Set user's facebook photo as the hero image
            if let facebookUserId = Auth.auth().currentUser?.providerData.first?.uid {
                let photoUrl = URL(string: "https://graph.facebook.com/\(facebookUserId)/picture?height=500")
                self.profileImage.sd_setImage(with: photoUrl)
            } else {
                self.profileImage.image = #imageLiteral(resourceName: "stu")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        
        switch source[indexPath.item] {
        case .showVersion:
            let app = AppDelegate.shared
            cell.textLabel?.text = "Version \(app.versionNumber) (\(app.buildNumber))"
        case let action:
            cell.textLabel?.text = action.rawValue
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch source[indexPath.row] {
        case .logout:
            logOut()
            return
        case .crash:
            MSCrashes.generateTestCrash()
            return
        case .testNotification:
            AppDelegate.shared.scheduleSampleNotification()
            return
        default:
            return
        }
    }
    
    func logOut() {
        UserViewModel.current.logout()
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
}
