//
//  EditUserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/20/22.
//

import SwiftUI
import Kingfisher

struct EditUserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var editUserProfileViewModel: ObservableViewModel<EditUserProfileState, EditUserProfileAction>
    @State var shouldShowImagePicker: Bool = false
    @State var shouldShowActionSheet: Bool = false
    @State var userImageUrl: String?
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userImageDidChange: Bool = false
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
            ButtonView(buttonImage: "chevron.left") {
                dismiss()
            }
        } rightItem: {
            EmptyView()
        } content: {
            VStack(spacing: 16) {
                Group {
                    if userImageDidChange {
                        if let userImageUrl = userImageUrl {
                            RemoteImageView(imageUrl: userImageUrl, isThumbnail: false)
                        } else {
                            ImageView(systemImage: "person.fill")
                        }
                    } else {
                        if let userImageUrl = editUserProfileViewModel.state.currentUserProfileImageUrl {
                            RemoteImageView(imageUrl: userImageUrl, isThumbnail: false)
                        } else {
                            ImageView(systemImage: "person.fill")
                        }
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
                        newUserImageUrl: userImageUrl,
                        userImageDidChange: userImageDidChange
                    ))
                } label: {
                    Text("Apply changes")
                }
                .disabled(userName == "" && userEmail == "" && !userImageDidChange)
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
                    userImageUrl = nil
                    userImageDidChange = true
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
            ImagePicker(sourceType: .photoLibrary, didFinishPickingMediaHandler: { newUserImageUrl in
                userImageUrl = newUserImageUrl
                userImageDidChange = true
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
