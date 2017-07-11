import Foundation
import UIKit

import ConfettiKit

import FirebaseAuth
import Firebase

import MobileCenterCrashes

protocol HeroStretchable {
    var tableView: UITableView! { get }
    var heroView: HeroView! { get }
}

extension HeroStretchable {
    private var tableHeaderHeight: CGFloat {
        return UIScreen.main.bounds.height / 2
    }
    
    // Call this in viewDidLoad
    func setupStretchyHero() {
        tableView.tableHeaderView = nil
        tableView.addSubview(heroView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
    }
    
    // Call this in scrollViewDidScroll
    func updateStretchyHero() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        heroView.frame = headerRect
    }
}

class ProfileViewController : UITableViewController, HeroStretchable {
    
    @IBOutlet weak var heroView: HeroView!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    enum Action: String {
        case logout = "Logout"
        case crash = "Crash the app!"
        case testNotification = "Send test notification"
        case showVersion = "showVersion"
    }
    
    let sections: [(title: String, actions: [Action])] = [
        (title: "Normal", actions: [
            .logout
        ]),
        (title: "Debug", actions: [
            .crash,
            .testNotification,
            .showVersion
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStretchyHero()
        styleTransparentNavigationBar()
        
        //Turn off pillView on profile page
        heroView.pillView.isHidden = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateStretchyHero()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // Set user's facebook photo as the hero image
            if let facebookUserId = Auth.auth().currentUser?.providerData.first?.uid {
                let photoUrl = URL(string: "https://graph.facebook.com/\(facebookUserId)/picture?height=500")
                self.heroView.heroImage.sd_setImage(with: photoUrl!)
            } else {
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        case _:
            cell = tableView.dequeueReusableCell(withIdentifier: "debug", for: indexPath)
        }
        
        let section = sections[indexPath.section]
        
        switch section.actions[indexPath.row] {
        case .showVersion:
            let app = AppDelegate.shared
            cell.textLabel?.text = "Version \(app.versionNumber) (\(app.buildNumber))"
        case let action:
            cell.textLabel?.text = action.rawValue
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        #if DEBUG
            return sections.count
        #else
            return 1
        #endif
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        #if DEBUG
            return sections[section].title
        #else
            return nil
        #endif
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].actions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case _:
            return 46
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch sections[indexPath.section].actions[indexPath.row] {
        case .logout:
            logOut()
        case .crash:
            MSCrashes.generateTestCrash()
        case .testNotification:
            AppDelegate.shared.scheduleSampleNotification()
        case .showVersion:
            UIApplication.shared.open(
                URL(string: "https://install.mobile.azure.com/orgs/confetti/apps/confetti-swift")!,
                options: [:]
            )
        }
    }
    
    func logOut() {
        UserViewModel.current.logout()
        AppDelegate.shared.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
}
