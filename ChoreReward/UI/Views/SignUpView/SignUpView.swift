//
//  SignupView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var signUpViewModel: ObservableViewModel<SignUpState, SignUpAction>
    private var views: Dependency.Views
    
    @State var nameInput: String = ""
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @State var roleSelection: Role = .parent
    
    init(
        signUpViewModel: ObservableViewModel<SignUpState, SignUpAction>,
        views: Dependency.Views
    ){
        self.signUpViewModel = signUpViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            Text(signUpViewModel.state.errorMessage)
                .padding()
            
            TextFieldView(textInput: $nameInput, title: "Full Name")
            TextFieldView(textInput: $emailInput, title: "Email")
            TextFieldView(textInput: $passwordInput, secured: true, title: "Password")
            RolePickerView(roleSelection: $roleSelection)
            ButtonView(
                action: {signUpViewModel.perform(
                    action: .signUp(
                        emailInput: emailInput,
                        nameInput: nameInput,
                        passwordInput: passwordInput,
                        roleSelection: roleSelection
                    )
                )},
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
            SignUpView(
                signUpViewModel: .init(staticState: .init(errorMessage: "")),
                views: Dependency.preview.views()
            )
        }
    }
}

extension Dependency.Views{
    var signUpView: SignUpView{
        return SignUpView(
            signUpViewModel:ObservableViewModel(viewModel: viewModels.signUpViewModel),
            views: self
        )
    }
}
