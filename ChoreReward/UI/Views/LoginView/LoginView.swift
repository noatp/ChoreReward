//
//  LoginView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    private var views: Dependency.Views
    
    init(
        loginViewModel: LoginViewModel,
        views: Dependency.Views
    ) {
        self.loginViewModel = loginViewModel
        self.views = views
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if (loginViewModel.errorMessage != nil){
                    Text(loginViewModel.errorMessage!)
                        .padding()
                }
                
                TextFieldView(textInput: $loginViewModel.emailInput, title: "Email")
                TextFieldView(textInput: $loginViewModel.passwordInput, secured: true, title: "Password")
                
                ButtonView(
                    action: loginViewModel.signIn,
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
        Dependency.preview.views().loginView
    }
}

extension Dependency.Views{
    var loginView: LoginView{
        return LoginView(
            loginViewModel: viewModels.loginViewModel,
            views: self
        )
    }
}
