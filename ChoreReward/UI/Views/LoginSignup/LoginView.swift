//
//  LoginView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import SwiftUI

// MARK: Main Implementaion

struct LoginView: View {
    @ObservedObject var loginViewModel: ObservableViewModel<LoginViewState, LoginViewAction>
    private var views: Dependency.Views

    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @FocusState private var focusedField: LoginFields?

    init(
        loginViewModel: ObservableViewModel<LoginViewState, LoginViewAction>,
        views: Dependency.Views
    ) {
        self.loginViewModel = loginViewModel
        self.views = views
    }

    var body: some View {
        UnwrapViewState(viewState: loginViewModel.viewState) { viewState in
            NavigationView {
                VStack(spacing: 0) {
                    Text("Chore Reward")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.accent)
                    Form {
                        RegularTextField(title: "Email", textInput: $emailInput)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .email)
                            .onSubmit {
                                focusedField = .password
                            }
                        SecuredTextField(title: "Password", textInput: $passwordInput)
                            .textContentType(.password)
                            .submitLabel(.done)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                login()
                            }
                        HStack {
                            Spacer()
                            RegularButton(buttonTitle: "Log in", buttonImage: "arrow.forward.to.line") {
                                login()
                            }
                            Spacer()
                        }
                    }
                    Divider()
                    HStack {
                        Text("Don't have an account?")
                        NavigationLink(destination: views.signUpView) {
                            Text("Sign up!")
                                .foregroundColor(.accent)
                        }
                    }
                    .smallVerticalPadding()
                }
                .vNavBar(NavigationBar(title: "Log in", leftItem: EmptyView(), rightItem: EmptyView()))
                .alert(
                    viewState.errorMessage,
                    isPresented: Binding<Bool>(
                        get: {
                            viewState.shouldShowAlert
                        },
                        set: { newState in
                            loginViewModel.perform(action: .updateShouldShowAlertState(newState: newState))
                        })
                ) {
                    RegularButton(buttonTitle: "OK") {}
                }
            }
        }
    }
}

// MARK: Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            loginViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )
        .font(StylingFont.regular)
        .previewLayout(.sizeThatFits)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var loginView: LoginView {
        return LoginView(
            loginViewModel: ObservableViewModel(viewModel: viewModels.loginViewModel),
            views: self
        )
    }
}

// MARK: Additional functionality

extension LoginView {
    private func login() {
        loginViewModel.perform(action: .signIn(
            emailInput: emailInput,
            passwordInput: passwordInput
        ))
    }

    private enum LoginFields: Int, Hashable {
        case email, password
    }
}
