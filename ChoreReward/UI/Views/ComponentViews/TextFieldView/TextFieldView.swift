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
        if #available(iOS 15.0, *) {
            TextField(
                textFieldViewModel.title,
                text: $textFieldViewModel.textInput,
                prompt: Text(textFieldViewModel.prompt)
            )
            .textInputAutocapitalization(TextInputAutocapitalization.never)

        } else {
            TextField(
                textFieldViewModel.title,
                text: $textFieldViewModel.textInput
            )
            .autocapitalization(UITextAutocapitalizationType.none)
        }
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
