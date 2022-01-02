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
        VStack(spacing: 16){
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(30)
                .overlay(RoundedRectangle(cornerRadius: 200)
                            .stroke())
            Text(userTabViewModel.currentUserName)
                .font(.title)
            HStack{
                Text("Email: ")
                Text(userTabViewModel.currentUserEmail)
            }

            HStack{
                Text("Role: ")
                Text(userTabViewModel.currentUserRole)
            }
            
            Spacer()
            
            Button("Sign out") {
                userTabViewModel.signOut()
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
