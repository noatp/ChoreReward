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
        ScrollView {
            VStack {
                Spacer()

                pickUserImageButton

                rolePicker
                    .smallVerticalPadding()
                NameTextField(textInput: $nameInput)
                    .submitLabel(.next)
                EmailTextField(textInput: $emailInput)
                    .submitLabel(.next)
                PasswordTextField(textInput: $passwordInput)
                    .submitLabel(.done)
                    .onSubmit {
                        signUp()
                    }

                FilledButtonView(buttonTitle: "Sign up.", buttonImage: "arrow.turn.right.up") {
                    signUp()
                }
                .smallVerticalPadding()
                Spacer()
            }
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
        .alert(
            signUpViewModel.state.errorMessage,
            isPresented: Binding<Bool>(
                get: {
                    signUpViewModel.state.shouldAlert
                },
                set: { newState in
                    signUpViewModel.perform(action: .updateShouldAlertState(newState: newState))
                })
        ) {
            RegularButtonView(buttonTitle: "OK") {}
        }
    }

}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            signUpViewModel: .init(staticState: .empty),
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
        RegularButtonView(buttonImage: "chevron.left") {
            dismiss()
        }
    }

    private var pickUserImageButton: some View {
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
    }

    private var rolePicker: some View {
        HStack {
            Text("You are a: ")
            Picker("Role", selection: $roleSelection) {
                Text("Parent").tag(Role.parent)
                Text("Child").tag(Role.child)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
    }

    private func signUp() {
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
}
