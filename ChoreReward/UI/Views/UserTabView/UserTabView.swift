//
//  UserTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct UserTabView: View {
    @ObservedObject var userTabViewModel: UserTabViewModel
    private var views: Dependency.Views
    
    init(
        userTabViewModel: UserTabViewModel,
        views: Dependency.Views
    ){
        self.userTabViewModel = userTabViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("signed in with email")
                Text(userTabViewModel.currentUserEmail)
            }
            HStack{
                Text("name:")
                Text(userTabViewModel.currentUserName)
            }
            HStack{
                Text("role")
                Text(userTabViewModel.currentUserRole)
            }
            
            Button("Sign out") {
                userTabViewModel.signOut()
            }
            
            Button("Get test1 account data"){
                userTabViewModel.getUserProfile(uid: "iZ3Ui5jeCpMu6ih3XGFHOekd81o2")
            }
        }
        .padding()
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().userTabView

    }
}

extension Dependency.Views{
    var userTabView: UserTabView{
        return UserTabView(
            userTabViewModel: viewModels.userTabViewModel,
            views: self
        )
    }
}
