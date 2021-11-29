//
//  SignupView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var signupViewModel: SignupViewModel
    
    init(dependency: Dependency = Dependency.shared){
        self.signupViewModel = dependency.signupViewModel
    }
    
    var body: some View {
        VStack{
            if (signupViewModel.errorMessage != nil){
                Text(signupViewModel.errorMessage!)
                    .padding()
            }
            
            TextFieldView(textFieldViewModel: signupViewModel.nameInputRender)
                .padding()
            TextFieldView(textFieldViewModel: signupViewModel.emailInputRender)
                .padding()
            TextFieldView(textFieldViewModel: signupViewModel.passwordInputRender)
                .padding()
            Button("Sign up") {
                signupViewModel.signUp()
            }
            .padding()
        }
        .padding()
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
