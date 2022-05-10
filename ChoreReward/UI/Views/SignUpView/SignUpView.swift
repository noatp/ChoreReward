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
    @State var shouldShowImagePicker: Bool = false
    @State var userImage: UIImage?
    
    init(
        signUpViewModel: ObservableViewModel<SignUpState, SignUpAction>,
        views: Dependency.Views
    ){
        self.signUpViewModel = signUpViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            Button {
                shouldShowImagePicker = true
            } label: {
                if let userImage = userImage {
                    Image(uiImage: userImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                else{
                    ZStack{
                        Circle()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.fg)
                            .shadow(radius: 5)
                        Text("Add profile picture")
                    }
                }
                   
            }
            .foregroundColor(.acc)
            //.buttonStyle(.plain)
            Text(signUpViewModel.state.errorMessage)
            
            
            TextFieldView(textInput: $nameInput, title: "Full Name")
            TextFieldView(textInput: $emailInput, title: "Email")
            TextFieldView(textInput: $passwordInput, secured: true, title: "Password")
            RolePickerView(roleSelection: $roleSelection)
            
            ButtonView(buttonTitle: "Sign up", buttonImage: "arrow.turn.right.up") {
                signUpViewModel.perform(
                    action: .signUp(
                        emailInput: emailInput,
                        nameInput: nameInput,
                        passwordInput: passwordInput,
                        roleSelection: roleSelection,
                        profileImage: userImage
                    )
                )
            }
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.automatic)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(sourceType: .photoLibrary, didFinishPickingMediaHandler: { newUserImage in
                userImage = newUserImage
            })
            .ignoresSafeArea()
        }
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
