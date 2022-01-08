//
//  SignupView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var signUpViewModel: SignUpViewModel
    private var views: Dependency.Views
    
    init(
        signUpViewModel: SignUpViewModel,
        views: Dependency.Views
    ){
        self.signUpViewModel = signUpViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            if (signUpViewModel.errorMessage != nil){
                Text(signUpViewModel.errorMessage!)
                    .padding()
            }
            
            TextFieldView(textInput: $signUpViewModel.nameInput, title: "Full Name")
            TextFieldView(textInput: $signUpViewModel.emailInput, title: "Email")
            TextFieldView(textInput: $signUpViewModel.passwordInput, secured: true, title: "Password")
            RolePickerView(rolePickerViewModel: signUpViewModel.rolePickerRender)
            ButtonView(
                action: signUpViewModel.signUp,
                buttonTitle: "Sign Up",
                buttonImage: "arrow.turn.right.up",
                buttonColor: .accentColor
            )
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Dependency.preview.views().signUpView
        }
    }
}

extension Dependency.Views{
    var signUpView: SignUpView{
        return SignUpView(
            signUpViewModel: viewModels.signUpViewModel,
            views: self
        )
    }
}
