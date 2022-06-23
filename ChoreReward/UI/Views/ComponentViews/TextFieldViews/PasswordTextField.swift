//
//  PasswordTextField.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/22/22.
//

import SwiftUI

struct PasswordTextField: View {
    @Binding var textInput: String

    init(
        textInput: Binding<String>
    ) {
        self._textInput = textInput
    }

    var body: some View {
        TextFieldView(title: "Password", textInput: $textInput, secured: true)
            .textContentType(.newPassword)
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField.init(textInput: .constant(""))
    }
}
