import Foundation
import UIKit

import ConfettiKit

import FirebaseAuth
import Firebase

import AppCenterCrashes

import FacebookLogin
import Firebase
import FirebaseAuth

protocol HeroStretchable where Self: UITableViewController {
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
        
        // Make stretchy header not be too tall
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
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
        case loginWithFacebook = "Login with Facebook"
        case crash = "Crash the app!"
        case testNotification = "Send test notification"
        case showVersion = "showVersion"
    }
    
    let actionSubtitles: [Action: String] = [
        .logout: "Wait but why?",
        .loginWithFacebook: "Please login to save & sync your events."
    ]
    
    let sections: [(title: String, actions: [Action])] = {
        var sections = [(title: String, actions: [Action])]()
        
        let loggedIn = (title: "Logged In", actions: [
            Action.logout
        ])
        
        let anonymous = (title: "Anonymous", actions: [
            Action.loginWithFacebook,
            .logout
        ])
        
        let debug = (title: "Debug", actions: [
            Action.crash,
            .testNotification,
            .showVersion
        ])
        
        if UserViewModel.current.isAnonymous {
            sections.append(anonymous)
        } else {
            sections.append(loggedIn)
        }
        
        if AppDelegate.shared.runMode == .debug {
            sections.append(debug)
        }
        
        return sections
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStretchyHero()
        styleTransparentNavigationBar()
        
        //Turn off pillView on profile page
        heroView.runMode = .profile
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
            cell.detailTextLabel?.text = actionSubtitles[action]
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if AppDelegate.shared.runMode == .debug {
            return sections[section].title
        } else {
            // We don't show multiple sections in release, so we hide the titles
            return nil
        }
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
        case .loginWithFacebook:
            loginWithFacebook()
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
    
    func loginWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                let app = AppDelegate.shared
                let savedEvents = Array(UserViewModel.current.events ?? [])
                
                let previousPage = app.window?.rootViewController
                let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
                
                // Display launchscreen while we make some network requests
                app.window?.rootViewController = launchScreen
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let _ = error {
                        app.window?.rootViewController = previousPage
                    } else if let _ = user {
                        app.launchApp(withParameter: .loggedIn)
                        savedEvents.forEach { UserViewModel.current.addEvent($0) }
                    }
                }
            }
        }
    }
}
