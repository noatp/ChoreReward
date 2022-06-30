//
//  EditUserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/20/22.
//

import SwiftUI

// MARK: Main Implementation

struct EditUserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var editUserProfileViewModel: ObservableViewModel<EditUserProfileState, EditUserProfileAction>
    @State var shouldShowImagePicker: Bool = false
    @State var shouldShowActionSheet: Bool = false
    @State var shouldShowAlert: Bool = false
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

            RegularButton(buttonTitle: "Change profile picture", action: {
                shouldShowActionSheet = true
            })
            .foregroundColor(.accent)

            Form {
                HStack {
                    Text("Name: ")
                        .frame(width: 60)
                    RegularTextField(title: editUserProfileViewModel.state.currentUserName, textInput: $userName)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                }
                HStack {
                    Text("Email: ")
                        .frame(width: 60)
                    RegularTextField(title: editUserProfileViewModel.state.currentUserEmail, textInput: $userEmail)
                        .textContentType(.password)
                        .keyboardType(.emailAddress)
                }
            }
        }
        .vNavBar(NavigationBar(
            title: editUserProfileViewModel.state.currentUserName,
            leftItem: backButton,
            rightItem: doneButton)
        )
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

// MARK: Preview

struct EditUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserProfileView(
            editUserProfileViewModel: ObservableViewModel(
                staticState: .preview
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var editUserProfileView: EditUserProfileView {
        return EditUserProfileView(
            editUserProfileViewModel: ObservableViewModel(viewModel: viewModels.editUserProfileViewModel),
            views: self
        )
    }
}

// MARK: Subviews

extension EditUserProfileView {
    var backButton: some View {
        RegularButton(buttonImage: "chevron.left") {
            dismiss()
        }
    }

    var doneButton: some View {
        RegularButton(buttonTitle: "Done") {
            submitChanges()
        }
    }
}

// MARK: Extra functionalities

extension EditUserProfileView {
    private func submitChanges() {
        if didMakeChanges() {
            editUserProfileViewModel.perform(action: .updateUserProfile(
                userName: userName,
                userEmail: userEmail,
                newUserImageUrl: userImageUrl,
                userImageDidChange: userImageDidChange
            ))
        }
        dismiss()
    }

    private func didMakeChanges() -> Bool {
        return userImageDidChange || !userName.isEmpty || !userEmail.isEmpty
    }
}
