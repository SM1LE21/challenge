//
//  NotificationManager.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error)")
            } else if granted {
                print("Notifications permission granted")
            } else {
                print("Notifications permission denied")
            }
        }
    }

    func scheduleNotification(title: String, body: String, in seconds: TimeInterval) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("Notifications are not authorized")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled in \(seconds) seconds")
                }
            }
        }
    }
}
