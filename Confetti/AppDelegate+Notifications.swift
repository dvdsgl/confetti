import Foundation
import UserNotifications

import ConfettiKit

import MobileCenterPush

extension AppDelegate {        
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
            print(granted)
        }
        
        // Clear old notifications from previous versions
        center.removeAllPendingNotificationRequests()
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MSPush.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        MSPush.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MSPush.didReceiveRemoteNotification(userInfo)
        completionHandler(.noData)
    }

    
    func notifications(for event: Event) -> [UNNotificationRequest] {
        let viewModel = EventViewModel.fromEvent(event)
        let baseDate = viewModel.nextOccurrence
        
        let calendar = Calendar.current
        
        return viewModel.notifications.map { spec in
            let content = UNMutableNotificationContent()
            content.title = spec.title
            content.body = spec.message
            content.sound = UNNotificationSound.default()
            
            let eventKey = ["eventKey": viewModel.event.key!]
            content.userInfo = eventKey
            
            let date = calendar.date(byAdding: .day, value: -spec.daysBefore, to: baseDate)!
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: DateComponents(
                    month: calendar.component(.month, from: date),
                    day: calendar.component(.day, from: date),
                    hour: 9
                ),
                repeats: false
            )
            
            let identifier = (viewModel.event.key ?? "") + spec.id
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            return request
        }
    }
    
    func scheduleNotifications(for events: [Event]) {
        let center = UNUserNotificationCenter.current()
        
        let notifications = events.flatMap { self.notifications(for: $0) }
        for notification in notifications {
            center.add(notification) { error in
                if error != nil {
                    // Handle any errors
                }
            }
        }
    }
    
    func scheduleSampleNotification(withDelay: TimeInterval = 0) {
        guard let events = UserViewModel.current.events else { return }
        
        let requests = events.flatMap { notifications(for: $0) }
        let request = requests[Int(arc4random_uniform(UInt32(requests.count)))]

        let newRequest = UNNotificationRequest(
            identifier: "sample",
            content: request.content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1.2 + withDelay, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: { error in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent: UNNotification,
                                withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // TODO differentiate push notifications
        withCompletionHandler(.alert)
    }
    
    // TODO: Handle what happens when user swipes on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            // The user dismissed the notification without taking action
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            guard let eventKey = response.notification.request.content.userInfo["eventKey"] as? String else { return }
            launchApp(withParameter: .openEvent(withKey: eventKey))
        }
        
        // Else handle any custom actions. . .
    }
}
