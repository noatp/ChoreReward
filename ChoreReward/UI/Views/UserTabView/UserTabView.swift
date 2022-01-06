//
//  UserTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct UserTabView: View {
    @ObservedObject var userTabViewModel: ObservableViewModel<UserTabState, UserTabAction>
    private var views: Dependency.Views
    
    init(
        userTabViewModel: ObservableViewModel<UserTabState, UserTabAction>,
        views: Dependency.Views
    ){
        self.userTabViewModel = userTabViewModel
        self.views = views
    }
    
    var body: some View {
        VStack(spacing: 16){
            HStack{
                Text("signed in with email")
                Text(userTabViewModel.state.currentUserEmail)
            }
            HStack{
                Text("name:")
                Text(userTabViewModel.state.currentUserName)
            }
            HStack{
                Text("role")
                Text(userTabViewModel.state.currentUserRole)
            }
            
            Button("Sign out") {
                userTabViewModel.action.signOut()
            }
        }
        .padding()
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView(
            userTabViewModel: ObservableViewModel(
                staticState: UserTabState(
                    currentUserEmail: "hello",
                    currentUserName: "buh",
                    currentUserRole: "here"
                ),
                staticAction: UserTabAction(signOut: {})
                
            ),
            views: Dependency.preview.views()
        )
    }
}

extension Dependency.Views{
    var userTabView: UserTabView{
        return UserTabView(
            userTabViewModel: ObservableViewModel(viewModel: viewModels.userTabViewModel),
            views: self
        )
    }
}


