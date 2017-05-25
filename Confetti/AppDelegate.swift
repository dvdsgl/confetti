import UIKit

import FacebookCore

import Firebase

import MobileCenter
import MobileCenterAnalytics
import MobileCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        MSMobileCenter.start("9c903184-9f6f-44d8-b1b4-01750b951ece", withServices:[
            MSAnalytics.self,
            MSCrashes.self
        ])
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        if let user = Auth.auth().currentUser {
            skipLogin(currentUser: user)
        } else {
            // User Not logged in
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
    
    func skipLogin(currentUser _: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let login = storyboard.instantiateInitialViewController()!
        window!.rootViewController = login
        
        let main = storyboard.instantiateViewController(withIdentifier: "loggedInViewController")
        main.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            login.present(main, animated: false)
        }
    }
}

