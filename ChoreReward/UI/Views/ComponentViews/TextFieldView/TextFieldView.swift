//
//  TextFieldView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import SwiftUI

struct TextFieldView: View {
    
    @ObservedObject private var textFieldViewModel: TextFieldViewModel
    
    init(
        textFieldViewModel: TextFieldViewModel
    ){
        self.textFieldViewModel = textFieldViewModel
    }
    
    var body: some View {
        Group{
            if (textFieldViewModel.secure){
                if #available(iOS 15.0, *) {
                    SecureField(
                        text: $textFieldViewModel.textInput,
                        prompt: Text(textFieldViewModel.prompt)) {
                            Text(textFieldViewModel.title)
                        }
                } else {
                    SecureField(
                        textFieldViewModel.title,
                        text: $textFieldViewModel.textInput
                    )
                }
            }
            else
                if #available(iOS 15.0, *) {
                    TextField(
                        text: $textFieldViewModel.textInput,
                        prompt: Text(textFieldViewModel.prompt)) {
                            Text(textFieldViewModel.title)
                        }
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                    
                } else {
                    TextField(
                        textFieldViewModel.title,
                        text: $textFieldViewModel.textInput
                    )
                        .autocapitalization(UITextAutocapitalizationType.none)
                }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())

    }
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TextFieldView(textFieldViewModel: TextFieldViewModel.preview)
        }
        .previewLayout(.sizeThatFits)
    }
}
