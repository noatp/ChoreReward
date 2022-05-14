//
//  ChoreRewardApp.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import SwiftUI
import Firebase

@main
struct ChoreRewardApp: App {
    let dependency: Dependency
    
    init(){
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        FirebaseApp.configure()
        self.dependency = .init()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
