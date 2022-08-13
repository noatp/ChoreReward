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
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        print("\(#fileID) \(#function): registering fore remote notification.")
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#fileID) \(#function): registered for remote notification")
        print("\(#fileID) \(#function): device token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
}
