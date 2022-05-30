//
//  UserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI
import Kingfisher

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: ObservableViewModel<UserProfileState, UserProfileAction>
    private var views: Dependency.Views
    
    init(
        userProfileViewModel: ObservableViewModel<UserProfileState, UserProfileAction>,
        views: Dependency.Views
    ){
        self.userProfileViewModel = userProfileViewModel
        self.views = views
    }
    
    var body: some View {
        RegularNavBarView(navTitle: userProfileViewModel.state.currentUserName) {
            VStack(spacing: 16){
                Group{
                    if let userImageUrl = userProfileViewModel.state.currentUserProfileImageUrl {
//                        RemoteImageView(
//                            imageUrl: userImageUrl,
//                            size: .init(width: 200, height: 200),
//                            cachingSize: .init(width: 200, height: 200)
//                        )
                        RemoteImageView(imageUrl: userImageUrl, isThumbnail: false)
                    }
                    else{
                        ImageView(systemImage: "person.fill", size: .init(width: 200, height: 200))
                    }
                }
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 5)
                
                Text(userProfileViewModel.state.currentUserName)
                    .font(.title)

                HStack{
                    Text("Email:")
                    Text(userProfileViewModel.state.currentUserEmail)
                }
                HStack{
                    Text("Role:")
                    Text(userProfileViewModel.state.currentUserRole)
                }
                
                Spacer()
                
                NavigationLink {
                    views.editUserProfileView
                } label: {
                    HStack{
                        Image(systemName: "pencil")
                        Text("Edit profile")
                    }
                }

                ButtonView(buttonTitle: "Log out", buttonImage: "arrow.backward.to.line") {
                    userProfileViewModel.perform(action: .signOut)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            UserProfileView(
                userProfileViewModel: ObservableViewModel(
                    staticState: UserProfileState(
                        currentUserEmail: "toan.chpham@gmail.com",
                        currentUserName: "Toan Pham",
                        currentUserRole: "Child",
                        currentUserProfileImageUrl: nil
                    )                    
                ),
                views: Dependency.preview.views()
            )
        }
        .preferredColorScheme(.dark)
    }
}

extension Dependency.Views{
    var userProfileView: UserProfileView{
        return UserProfileView(
            userProfileViewModel: ObservableViewModel(viewModel: viewModels.userProfileViewModel),
            views: self
        )
    }
}


