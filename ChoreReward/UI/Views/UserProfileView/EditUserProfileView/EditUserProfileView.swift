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
    @State var userImageUrl: String?
    @State var userName: String = ""
    @State var userEmail: String = ""
    private var views: Dependency.Views

    init(
        editUserProfileViewModel: ObservableViewModel<EditUserProfileState, EditUserProfileAction>,
        views: Dependency.Views
    ) {
        self.editUserProfileViewModel = editUserProfileViewModel
        self.views = views
    }

    var body: some View {
        RegularNavBarView(navTitle: editUserProfileViewModel.state.currentUserName) {
            VStack(spacing: 16) {
                Group {
                    if let userImageUrl = userImageUrl {
                        RemoteImageView(imageUrl: userImageUrl, isThumbnail: false)
                    } else if let userImageUrlFromRemote = editUserProfileViewModel.state.currentUserProfileImageUrl {
                        RemoteImageView(imageUrl: userImageUrlFromRemote, isThumbnail: false)
                    } else {
                        ImageView(systemImage: "person.fill")
                    }
                }
                .frame(width: 200, height: 200, alignment: .center)
                .clipShape(Circle())

                ButtonView(buttonTitle: "Change profile picture", action: {
                    shouldShowActionSheet = true
                })
                .foregroundColor(.acc)
                Divider()
                VStack {
                    HStack {
                        Text("Name: ")
                            .frame(width: 60)
                        TextFieldView(title: editUserProfileViewModel.state.currentUserName, textInput: $userName)
                    }
                    HStack {
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
                        userImageUrl: userImageUrl
                    ))
                } label: {
                    Text("Apply changes")
                }
                .disabled(userName == "" && userEmail == "" && userImageUrl == nil)
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
                    shouldShowImagePicker = true
                } label: {
                    Text("Choose from library")
                }
            }
        )
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(sourceType: .photoLibrary, didFinishPickingMediaHandler: { newUserImageUrl in
                userImageUrl = newUserImageUrl
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

extension Dependency.Views {
    var editUserProfileView: EditUserProfileView {
        return EditUserProfileView(
            editUserProfileViewModel: ObservableViewModel(viewModel: viewModels.editUserProfileViewModel),
            views: self
        )
    }
}
