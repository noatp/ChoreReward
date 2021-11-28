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
    
    var body: some View {
        VStack{
            if (loginViewModel.errorMessage != nil){
                Text(loginViewModel.errorMessage!)
            }
            
            TextFieldView(textFieldViewModel: loginViewModel.emailInputRender)
            TextFieldView(textFieldViewModel: loginViewModel.passwordInputRender)
            
            Button("Log in") {
                loginViewModel.signIn()
            }
            
            Button("Sign up") {
                loginViewModel.signUp()
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
