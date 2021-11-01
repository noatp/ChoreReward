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
    init(){
        FirebaseApp.configure();
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
