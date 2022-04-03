//
//  UserTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct UserTabView: View {
    @ObservedObject var userTabViewModel: ObservableViewModel<UserTabState, UserTabAction>
    @State var shouldShowImagePicker: Bool = false
    @State var userImage: UIImage? = nil
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
            Button {
                shouldShowImagePicker = true
            } label: {
                if let userImage = userImage {
                    Image(uiImage: userImage)
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
                action: {userTabViewModel.perform(action: .signOut)},
                buttonTitle: "Log Out",
                buttonImage: "arrow.backward.to.line",
                buttonColor: .red
            )
        }
        .padding()
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $userImage)
                        .ignoresSafeArea()
                }
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
                    )                    
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


