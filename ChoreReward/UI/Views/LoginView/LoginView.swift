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
        NavigationView{
            VStack{
                Text(loginViewModel.state.errorMessage)
                    .padding()
                
                TextFieldView(textInput: $emailInput, title: "Email")
                TextFieldView(textInput: $passwordInput, secured: true, title: "Password")
                
                ButtonView(
                    action: {loginViewModel.perform(
                        action: .signIn(emailInput: emailInput, passwordInput: passwordInput))
                    },
                    buttonTitle: "Log In",
                    buttonImage: "arrow.forward.to.line",
                    buttonColor: Color.accentColor
                )
            
                NavigationLink(destination: views.signUpView) {
                    Label("Sign Up with Email", systemImage: "arrow.turn.right.up")
                }
                .padding()
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .navigationViewStyle(.stack)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LoginView(
                loginViewModel: .init(staticState: .init(errorMessage: "")),
                views: Dependency.preview.views()
            )
        }
    }
}

extension Dependency.Views{
    var loginView: LoginView{
        return LoginView(
            loginViewModel: ObservableViewModel(viewModel: viewModels.loginViewModel),
            views: self
        )
    }
}
