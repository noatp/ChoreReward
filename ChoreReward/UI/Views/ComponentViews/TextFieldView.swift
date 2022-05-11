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
    
    init(
        title: String,
        textInput: Binding<String>,
        secured: Bool = false
    ){
        self._textInput = textInput
        self.secured = secured
        self.title = title
    }
    
    var body: some View {
        
        Group{
            if (secured){
                SecureField(text: $textInput) {
                    Text(title)
                }
            }
            else{
                TextField(text: $textInput) {
                    Text(title)
                }
            }
        }
        .autocapitalization(UITextAutocapitalizationType.none)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .shadow(radius: 1)
    }
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TextFieldView(title: "Preview", textInput: .constant(""), secured: true)
            TextFieldView(title: "Preview", textInput: .constant(""))
        }
        .previewLayout(.sizeThatFits)
    }
}
