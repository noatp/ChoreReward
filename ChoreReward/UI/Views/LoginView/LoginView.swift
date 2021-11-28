//
//  LoginView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    
    init(dependency: Dependency = .preview) {
        self.loginViewModel = dependency.loginViewModel
    }
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack{
            if #available(iOS 15.0, *) {
                TextFieldView(textFieldViewModel: loginViewModel.emailInputRender)
                    .textInputAutocapitalization(TextInputAutocapitalization.never)
            } else {
                TextFieldView(textFieldViewModel: loginViewModel.emailInputRender)
                    .autocapitalization(UITextAutocapitalizationType.none)
            }

            if #available(iOS 15.0, *) {
                TextFieldView(textFieldViewModel: loginViewModel.passwordInputRender)
                    .textInputAutocapitalization(TextInputAutocapitalization.never)
            } else {
                TextFieldView(textFieldViewModel: loginViewModel.passwordInputRender)
                    .autocapitalization(UITextAutocapitalizationType.none)
            }
            
            Button("Log in") {
                loginViewModel.signIn()
            }
            
            Button("Sign up") {
                loginViewModel.signUp()
            }
            
            Button("Log out") {
                loginViewModel.signOut()
            }
            
            loginViewModel.isSignedIn ? Text("signed in") : Text("not signed in")
            
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
