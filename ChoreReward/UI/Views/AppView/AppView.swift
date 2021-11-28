//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    init(dependency: Dependency = .preview){
        self.appViewModel = dependency.appViewModel
    }
    
    var body: some View {
        VStack{
            Text("signed in with uid")
            Text(appViewModel.getCurrentUserUUID())
            Button("Sign out") {
                appViewModel.signOut()
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
