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
        UnwrapViewState(viewState: signUpViewModel.viewState) { viewState in
            VStack(spacing: 0) {
                Form {
                    HStack {
                        Spacer()
                        pickUserImageButton
                        Spacer()
                    }
                    rolePicker
                    RegularTextField(title: "Name", textInput: $nameInput)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .name)
                        .onSubmit {
                            focusedField = .email
                        }
                    RegularTextField(title: "Email", textInput: $emailInput)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .email
                        )
                        .onSubmit {
                            focusedField = .password
                        }
                    SecuredTextField(title: "Password", textInput: $passwordInput)
                        .textContentType(.password)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            signUp()
                        }
                }
                RegularButton(buttonTitle: "Sign up", buttonImage: "arrow.turn.right.up") {
                    signUp()
                }
            }
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
                viewState.errorMessage,
                isPresented: Binding<Bool>(
                    get: {
                        viewState.shouldShowAlert
                    },
                    set: { newState in
                        signUpViewModel.perform(action: .updateShouldShowAlertState(newState: newState))
                    })
            ) {
                RegularButton(buttonTitle: "OK") {}
            }
        }
    }

}

// MARK: Preview

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            signUpViewModel: .init(staticState: .preview),
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
        RegularButton(buttonImage: "chevron.left") {
            dismiss()
        }
    }

    private var pickUserImageButton: some View {
        Button {
            shouldShowImagePicker = true
        } label: {
            if let userImageUrl = userImageUrl {
                RemoteImage(imageUrl: userImageUrl)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } else {
                ZStack {
                    Circle()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.bg)
                        .shadow(radius: 1)
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
