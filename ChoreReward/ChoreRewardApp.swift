//
//  ChoreRewardApp.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseMessaging

@main
struct ChoreRewardApp: App {
    let dependency: Dependency

    @UIApplicationDelegateAdaptor private var appDelegate: ChoreRewardAppDelegate

    init() {
        FirebaseApp.configure()
        self.dependency = .init()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
