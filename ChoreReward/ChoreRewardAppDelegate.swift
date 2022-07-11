//
//  ChoreRewardAppDelegate.swift
//  ChoreReward
//
//  Created by Toan Pham on 7/10/22.
//

import Foundation
import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit

class ChoreRewardAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {
                return
            }
            print("Successfully register APNS")
        }
        application.registerForRemoteNotifications()
        return true
    }
}

extension ChoreRewardAppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}

extension ChoreRewardAppDelegate: UNUserNotificationCenterDelegate {

}
