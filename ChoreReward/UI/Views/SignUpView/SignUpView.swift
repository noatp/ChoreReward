//
//  SignupView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var signUpViewModel: ObservableViewModel<SignUpState, SignUpAction>
    private var views: Dependency.Views

    @State var nameInput: String = ""
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @State var roleSelection: Role = .parent
    @State var shouldShowImagePicker: Bool = false
    @State var userImageUrl: String?

    init(
        signUpViewModel: ObservableViewModel<SignUpState, SignUpAction>,
        views: Dependency.Views
    ) {
        self.signUpViewModel = signUpViewModel
        self.views = views
    }

    var body: some View {
        VStack {
            Spacer()
            Button {
                shouldShowImagePicker = true
            } label: {
                if let userImageUrl = userImageUrl {
                    RemoteImageView(imageUrl: userImageUrl, isThumbnail: false)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                } else {
                    ZStack {
                        Circle()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.fg)
                            .shadow(radius: 5)
                        Text("Add profile picture")
                    }
                }

            }
            .foregroundColor(.acc)
            Spacer()
            Text(signUpViewModel.state.errorMessage)

            TextFieldView(title: "Name", textInput: $nameInput)
            TextFieldView(title: "Email", textInput: $emailInput)
            TextFieldView(title: "Password", textInput: $passwordInput, secured: true)
            RolePickerView(roleSelection: $roleSelection)

            ButtonView(buttonTitle: "Sign up", buttonImage: "arrow.turn.right.up") {
                signUpViewModel.perform(
                    action: .signUp(
                        emailInput: emailInput,
                        nameInput: nameInput,
                        passwordInput: passwordInput,
                        roleSelection: roleSelection,
                        userImageUrl: userImageUrl
                    )
                )
            }
            Spacer()
        }
        .padding()
        .vNavBar(NavigationBar(
            title: "Sign up",
            leftItem: backButton,
            rightItem: EmptyView())
        )
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(sourceType: .photoLibrary, didFinishPickingMediaHandler: { newUserImageUrl in
                userImageUrl = newUserImageUrl
            })
            .ignoresSafeArea()
        }
    }

}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            signUpViewModel: .init(staticState: .init(errorMessage: "")),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

extension Dependency.Views {
    var signUpView: SignUpView {
        return SignUpView(
            signUpViewModel: ObservableViewModel(viewModel: viewModels.signUpViewModel),
            views: self
        )
    }
}

extension SignUpView {
    private var backButton: some View {
        ButtonView(buttonImage: "chevron.left") {
            dismiss()
        }
    }
}
