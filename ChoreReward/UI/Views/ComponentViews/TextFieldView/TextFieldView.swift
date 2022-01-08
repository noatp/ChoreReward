//
//  TextFieldView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import SwiftUI

struct TextFieldView: View {
    
    @Binding var textInput: String
    private var secured: Bool
    private var title: String
    private var prompt: String
    
    init(
        textInput: Binding<String>,
        secured: Bool = false,
        title: String,
        prompt: String = ""
    ){
        self._textInput = textInput
        self.secured = secured
        self.title = title
        self.prompt = prompt
    }
    
    var body: some View {
        Group{
            if (secured){
                SecureField(title, text: $textInput)
            }
            else{
                TextField(title, text: $textInput)
            }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(UITextAutocapitalizationType.none)
    }
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TextFieldView(textInput: Binding(get: {""}, set: {_ in }), title: "Preview")
        }
        .previewLayout(.sizeThatFits)
    }
}
