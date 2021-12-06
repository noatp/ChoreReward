//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var appViewModel: AppViewModel
    private var views: Dependency.Views
    
    init(
        appViewModel: AppViewModel,
        views: Dependency.Views
    ){
        self.appViewModel = appViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("signed in with email")
                Text(appViewModel.currentUserEmail)
            }
            HStack{
                Text("name:")
                Text(appViewModel.currentUserName)
            }
            HStack{
                Text("role")
                Text(appViewModel.currentUserRole)
            }
            
            Button("Sign out") {
                appViewModel.signOut()
            }
            
            Button("Get test1 account data"){
                appViewModel.getUserProfile(uid: "iZ3Ui5jeCpMu6ih3XGFHOekd81o2")
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().appView
    }
}

extension Dependency.Views{
    var appView: AppView{
        return AppView(
            appViewModel: viewModels.appViewModel,
            views: self
        )
    }
}
