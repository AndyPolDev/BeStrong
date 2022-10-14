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
    
    
    
}
