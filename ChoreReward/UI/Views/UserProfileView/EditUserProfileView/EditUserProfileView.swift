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
                            ImageView(uiImage: userImage, size: .init(width: 200, height: 200))
                        }
                        else{
                            ImageView(systemImage: "person.fill", size: .init(width: 200, height: 200))
                        }
                    }
                    else {
                        if let userImageUrl = editUserProfileViewModel.state.currentUserProfileImageUrl {
                            RemoteImageView(imageUrl: userImageUrl, size: .init(width: 200, height: 200))
                        }
                        else{
                            ImageView(systemImage: "person.fill", size: .init(width: 200, height: 200))
                        }
                    }
                }
                .clipShape(Circle())
                .shadow(radius: 5)
               
                ButtonView(buttonTitle: "Change profile picture", action: {
                    shouldShowActionSheet = true
                })
                .foregroundColor(.acc)
                Divider()
                VStack{
                    HStack{
                        Text("Name: ")
                            .frame(width: 60)
                        TextFieldView(title: editUserProfileViewModel.state.currentUserName, textInput: $userName)
                    }
                    HStack{
                        Text("Email: ")
                            .frame(width: 60)
                        TextFieldView(title: editUserProfileViewModel.state.currentUserEmail, textInput: $userEmail)
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
            ImagePicker(sourceType: .photoLibrary, didFinishPickingMediaHandler: { newUserImage in
                userImage = newUserImage
                didChangeProfileImage = true
            })
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



