import UIKit
import UserNotifications

class Notifications: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                guard granted else { return }
                self.getNotificationSettings()
            }
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            // print(settings)
        }
    }
    
    func scheduleDateNotification(date: Date, id: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "WORKOUT"
        content.body = "You have training today"
        content.sound = .default
        content.badge = 1
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        var triggerDate = calendar.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 12
        triggerDate.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if error != nil {
                print(error?.localizedDescription ?? "Notification error")
            }
        }
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.removeAllDeliveredNotifications()
    }
}
