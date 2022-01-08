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
            Image(systemName: "person.fill")
                .font(.system(size: 200))
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 120)
                        .stroke(lineWidth: 4)
                        .frame(width: 240, height: 240)
                )
            Text(userTabViewModel.state.currentUserName)
                .font(.title)


            HStack{
                Text("Email:")
                Text(userTabViewModel.state.currentUserEmail)
            }
            HStack{
                Text("Role:")
                Text(userTabViewModel.state.currentUserRole)
            }
            
            Spacer()
            
            ButtonView(
                action: userTabViewModel.action.signOut,
                buttonTitle: "Log Out",
                buttonImage: "arrow.backward.to.line",
                buttonColor: .red
            )
        }
        .padding()
        .navigationTitle("Hello, \(userTabViewModel.state.currentUserName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            UserTabView(
                userTabViewModel: ObservableViewModel(
                    staticState: UserTabState(
                        currentUserEmail: "toan.chpham@gmail.com",
                        currentUserName: "Toan Pham",
                        currentUserRole: "Child"
                    ),
                    staticAction: UserTabAction(signOut: {})
                    
                ),
                views: Dependency.preview.views()
            )
        }
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


