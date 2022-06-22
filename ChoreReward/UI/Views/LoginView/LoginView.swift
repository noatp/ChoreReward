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
                Text(loginViewModel.state.errorMessage)
                    .padding()

                TextFieldView(title: "Email", textInput: $emailInput)
                TextFieldView(title: "Password", textInput: $passwordInput, secured: true)

                ButtonView(buttonTitle: "Login", buttonImage: "arrow.forward.to.line") {
                    loginViewModel.perform(action: .signIn(emailInput: emailInput, passwordInput: passwordInput))
                }

                NavigationLink(destination: views.signUpView) {
                    Label("Sign Up with Email", systemImage: "arrow.turn.right.up")
                }
                .padding()
            }
            .padding()
            .vNavBar(NavigationBar(title: "Log in", leftItem: EmptyView(), rightItem: EmptyView()))
            .onAppear(perform: {
                loginViewModel.perform(action: .silentSignIn)
            })
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            loginViewModel: .init(staticState: .init(errorMessage: "")),
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
