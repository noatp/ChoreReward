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
        print("LOL")
        application.registerForRemoteNotifications()
        return true
    }
}
