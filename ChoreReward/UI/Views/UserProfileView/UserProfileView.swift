//
//  UserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI
import Kingfisher

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: ObservableViewModel<UserTabState, UserTabAction>
    @State var shouldShowImagePicker: Bool = false
    @State var userImage: UIImage? = nil
    private var views: Dependency.Views
    
    init(
        userProfileViewModel: ObservableViewModel<UserTabState, UserTabAction>,
        views: Dependency.Views
    ){
        self.userProfileViewModel = userProfileViewModel
        self.views = views
    }
    
    var body: some View {
        RegularNavBarView(navTitle: userProfileViewModel.state.currentUserName) {
            VStack(spacing: 16){
                Button {
                    shouldShowImagePicker = true
                } label: {
                    if let userImageUrl = userProfileViewModel.state.currentUserProfileImageUrl {
                        KFImage(URL(string: userImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    else{
                        ZStack{
                            Circle()
                                .frame(width: 200, height: 200)
                                .foregroundColor(.fg)
                                .shadow(radius: 5)
                            Text("Add profile picture")
                        }
                    }
                }
                
                
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
                
                ButtonView(
                    action: {userProfileViewModel.perform(action: .signOut)},
                    buttonTitle: "Log Out",
                    buttonImage: "arrow.backward.to.line",
                    buttonColor: .red
                )
            }
            .padding()
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $userImage).ignoresSafeArea()
        }
        .onChange(of: userImage) { newValue in
            guard let userImage = userImage else {
                print("\(#function): cannot update with a nil image")
                return
            }
            userProfileViewModel.perform(action: .changeUserProfileImage(image: userImage))
        }
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            UserProfileView(
                userProfileViewModel: ObservableViewModel(
                    staticState: UserTabState(
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


