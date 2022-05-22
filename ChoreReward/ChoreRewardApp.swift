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

@main
struct ChoreRewardApp: App {
    let dependency: Dependency
    
    init(){
//        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        FirebaseApp.configure()
#if EMULATORS
        print("""
            **********************************
            Testing on Emulators
            **********************************
        """)
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
#elseif DEBUG
        print("""
            **********************************
            Testing on Live Server
            **********************************
        """)
#endif
        self.dependency = .init()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
