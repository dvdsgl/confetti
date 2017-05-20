import UIKit

import FacebookCore

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
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
        let viewController = storyboard.instantiateViewController(withIdentifier :"masterViewController")
        window!.rootViewController = viewController
    }
}

