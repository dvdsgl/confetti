import UIKit

import FacebookCore

import Firebase

import AppCenter
import AppCenterCrashes
import AppCenterAnalytics
import AppCenterDistribute
import AppCenterPush

import NotificationCenter
import UserNotifications

import ConfettiKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate! as! AppDelegate
    }
    
    enum RunMode {
        case normal, debug, testRun
    }
    
    private(set) var runMode: RunMode = .normal {
        didSet {
            switch runMode {
            case .normal, .debug:
                UIView.setAnimationsEnabled(true)
            case .testRun:
                UIView.setAnimationsEnabled(false)
            }
        }
    }
    
    enum LaunchParamater {
        case loggedOut
        case loggedIn
        case openEvent(withKey: String)
    }
    
    func launchApp(withParameter param: LaunchParamater) {
        switch param {
        case .loggedOut:
            // Set root view controller to login screen (automatic for now)
            break
        case .loggedIn:
            UserViewModel.current.beginSession()
            window?.rootViewController = viewController("loggedInViewController")
            
        case let .openEvent(withKey: key):
            UserViewModel.current.beginSession()
            guard let tabs: CustomTabBarController = viewController("loggedInViewController") else { return }
            guard let nav = tabs.viewControllers?.first as? UINavigationController else { return }
            guard let eventList = nav.viewControllers.first as? EventListViewController else { return }
            
            eventList.launchEventKey = key
            
            window?.rootViewController = tabs
        }
    }
    
    var versionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
    var window: UIWindow?
   
    var appCenterServices: [AnyClass] {
        switch runMode {
        case .testRun:
            return [
                MSAnalytics.self,
                MSCrashes.self,
                // MSDistribute.self, // Distribution is turned off for tests
                MSPush.self
            ]
        default:
            return [
                MSAnalytics.self,
                MSCrashes.self,
                MSDistribute.self,
                MSPush.self
            ]
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        runMode = .debug
        #endif
        
        if ProcessInfo.processInfo.arguments.contains("test") {
            runMode = .testRun
        }
                
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        MSAppCenter.start("9c903184-9f6f-44d8-b1b4-01750b951ece", withServices: appCenterServices)
                
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let _ = Notifications.EventsChanged.subscribe { events in
            let soon = events.map { EventViewModel.fromEvent($0) }.filter { $0.isSoon }
            UIApplication.shared.applicationIconBadgeNumber = soon.count
            
            self.scheduleNotifications(for: events)
        }

        if let _ = Auth.auth().currentUser {
            launchApp(withParameter: .loggedIn)
        } else {
            launchApp(withParameter: .loggedOut)
        }
        
        if runMode != .testRun {
            setupNotifications()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        MSDistribute.open(url)
        
        let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
        return handled
    }
}

