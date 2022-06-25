//
//  SignupView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

// MARK: Main Implementaion

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
    @FocusState private var focusedField: SignUpFields?

    init(
        signUpViewModel: ObservableViewModel<SignUpState, SignUpAction>,
        views: Dependency.Views
    ) {
        self.signUpViewModel = signUpViewModel
        self.views = views
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()

                    pickUserImageButton

                    rolePicker
                        .smallVerticalPadding()
                    NameTextField(textInput: $nameInput)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .name)
                        .onSubmit {
                            focusedField = .email
                        }
                    EmailTextField(textInput: $emailInput)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .email
                        )
                        .onSubmit {
                            focusedField = .password
                        }
                    PasswordTextField(textInput: $passwordInput)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            signUp()
                        }

                    FilledButtonView(buttonTitle: "Sign up.", buttonImage: "arrow.turn.right.up") {
                        signUp()
                    }
                    .smallVerticalPadding()
                    Spacer()
                }
                .frame(height: proxy.size.height)
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

// MARK: Preview

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            signUpViewModel: .init(staticState: .empty),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var signUpView: SignUpView {
        return SignUpView(
            signUpViewModel: ObservableViewModel(viewModel: viewModels.signUpViewModel),
            views: self
        )
    }
}

// MARK: Subviews

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
        .foregroundColor(.accent)
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
}

// MARK: Additional functionality

extension SignUpView {
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

    private enum SignUpFields: Int, Hashable {
        case name, email, password
    }
}
