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
                    .padding()
            }
            
            TextFieldView(textFieldViewModel: loginViewModel.emailInputRender)
                .padding()
            TextFieldView(textFieldViewModel: loginViewModel.passwordInputRender)
                .padding()
            
            Button("Log in") {
                loginViewModel.signIn()
            }
            .padding()
        
            NavigationLink(destination: SignupView(dependency: Dependency.shared)) {
                Text("Sign up with email")
            }
            .padding()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
