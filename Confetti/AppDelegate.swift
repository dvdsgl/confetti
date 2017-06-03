import UIKit

import FacebookCore

import Firebase

import MobileCenter
import MobileCenterCrashes
import MobileCenterAnalytics
import MobileCenterDistribute

import NotificationCenter
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        MSMobileCenter.start("9c903184-9f6f-44d8-b1b4-01750b951ece", withServices:[
            MSAnalytics.self,
            MSCrashes.self,
            MSDistribute.self
        ])
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        if let user = Auth.auth().currentUser {
            skipLogin(currentUser: user)
        } else {
            // User Not logged in
        }
        
        // Set up local notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        return true
    }
    
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        withCompletionHandler(UNNotificationPresentationOptions.sound)
        print("Called in foreground")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        MSDistribute.open(url)
        
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

