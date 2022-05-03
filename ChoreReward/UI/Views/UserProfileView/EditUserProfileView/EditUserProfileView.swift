//
//  EditUserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/20/22.
//

import SwiftUI
import Kingfisher

struct EditUserProfileView: View {
    @ObservedObject var editUserProfileViewModel: ObservableViewModel<EditUserProfileState, EditUserProfileAction>
    @State var shouldShowImagePicker: Bool = false
    @State var shouldShowActionSheet: Bool = false
    @State var userImage: UIImage?
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var didChangeProfileImage: Bool = false
    private var views: Dependency.Views
    
    init(
        editUserProfileViewModel: ObservableViewModel<EditUserProfileState, EditUserProfileAction>,
        views: Dependency.Views
    ){
        self.editUserProfileViewModel = editUserProfileViewModel
        self.views = views
    }
    
    var body: some View {
        RegularNavBarView(navTitle: editUserProfileViewModel.state.currentUserName) {
            VStack(spacing: 16){
                Group{
                    if didChangeProfileImage {
                        if let userImage = userImage {
                            Image(uiImage: userImage).resizable()
                        }
                        else{
                            Image(systemName: "person.fill").resizable()
                        }
                    }
                    else {
                        if let userImageUrl = editUserProfileViewModel.state.currentUserProfileImageUrl {
                            KFImage(URL(string: userImageUrl)).resizable()
                        }
                        else{
                            Image(systemName: "person.fill").resizable()
                        }
                    }
                }
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 5)
               
                ButtonView(buttonTitle: "Change profile picture", action: {
                    shouldShowActionSheet = true
                })
                .foregroundColor(.acc)
                Divider()
                HStack{
                    VStack{
                        Text("Name: ")
                        Divider().frame(width: 0)
                        Text("Email: ")
                    }
                    VStack{
                        TextField("userName",
                                  text: $userName,
                                  prompt: Text(editUserProfileViewModel.state.currentUserName))
                        .textInputAutocapitalization(.never)
                        Divider()
                        TextField("userEmail",
                                  text: $userEmail,
                                  prompt: Text(editUserProfileViewModel.state.currentUserEmail))
                        .textInputAutocapitalization(.never)
                    }
                }
                
                Divider()
                Button {
                    editUserProfileViewModel.perform(action: .updateUserProfile(
                        userName: userName,
                        userEmail: userEmail,
                        userImage: userImage,
                        didChangeProfileImage: didChangeProfileImage
                    ))
                } label: {
                    Text("Apply changes")
                }
                .disabled(userName == "" && userEmail == "" && !didChangeProfileImage)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .confirmationDialog(
            "Change profile picture",
            isPresented: $shouldShowActionSheet,
            titleVisibility: .visible,
            actions: {
                Button {
                    userImage = nil
                    didChangeProfileImage = true
                } label: {
                    Text("Remove profile picture")
                }

                Button {
                    shouldShowImagePicker = true
                } label: {
                    Text("Choose from library")
                }
            }
        )
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(
                image: $userImage,
                didChangeProfileImage: $didChangeProfileImage
            )
            .ignoresSafeArea()
        }
    }
}

struct EditUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserProfileView(
            editUserProfileViewModel: ObservableViewModel(
                staticState: .preview
            ),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.light)
    }
}

extension Dependency.Views{
    var editUserProfileView: EditUserProfileView{
        return EditUserProfileView(
            editUserProfileViewModel: ObservableViewModel(viewModel: viewModels.editUserProfileViewModel),
            views: self
        )
    }
}



