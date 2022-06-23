//
//  LoginView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: ObservableViewModel<LoginViewState, LoginViewAction>
    private var views: Dependency.Views

    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    var shouldAlert: Bool {
        loginViewModel.state.shouldAlert
    }

    init(
        loginViewModel: ObservableViewModel<LoginViewState, LoginViewAction>,
        views: Dependency.Views
    ) {
        self.loginViewModel = loginViewModel
        self.views = views
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                TextFieldView(title: "Email", textInput: $emailInput)
                    .smallVerticalPadding()
                TextFieldView(title: "Password", textInput: $passwordInput, secured: true)
                    .smallVerticalPadding()

                FilledButtonView(buttonTitle: "Log in", buttonImage: "arrow.forward.to.line") {
                    loginViewModel.perform(action: .signIn(emailInput: emailInput, passwordInput: passwordInput))
                }
                .smallVerticalPadding()

                Spacer()

                Divider()
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: views.signUpView) {
                        Text("Sign Up")
                    }
                }
            }
            .padding()
            .vNavBar(NavigationBar(title: "Log in", leftItem: EmptyView(), rightItem: EmptyView()))
            .onAppear(perform: {
                loginViewModel.perform(action: .silentSignIn)
            })
            .alert(
                loginViewModel.state.errorMessage,
                isPresented: Binding<Bool>(
                    get: {
                        loginViewModel.state.shouldAlert
                    },
                    set: { newState in
                        loginViewModel.perform(action: .updateShouldAlertState(newState: newState))
                    })
            ) {
                RegularButtonView(buttonTitle: "OK") {}
            }
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            loginViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

extension Dependency.Views {
    var loginView: LoginView {
        return LoginView(
            loginViewModel: ObservableViewModel(viewModel: viewModels.loginViewModel),
            views: self
        )
    }
}
