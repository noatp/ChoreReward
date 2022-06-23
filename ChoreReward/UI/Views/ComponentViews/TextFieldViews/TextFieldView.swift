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
    ) {
        self._textInput = textInput
        self.secured = secured
        self.title = title
    }

    var body: some View {
        Group {
            if secured {
                SecureField(text: $textInput) {
                    Text(title)
                }
            } else {
                TextField(text: $textInput) {
                    Text(title)
                }
            }
        }
        .frame(height: 40)
        .textFieldStyle(PlainTextFieldStyle())
        .padding([.horizontal], 15)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray))
        .shadow(radius: 1)
        .smallVerticalPadding()
        .autocapitalization(UITextAutocapitalizationType.none)
        .disableAutocorrection(true)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TextFieldView(title: "Preview", textInput: .constant(""), secured: true)
            TextFieldView(title: "Preview", textInput: .constant(""))
        }
        .previewLayout(.sizeThatFits)
    }
}
