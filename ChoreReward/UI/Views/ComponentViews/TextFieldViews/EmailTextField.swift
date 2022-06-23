//
//  EmailTextField.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/22/22.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var textInput: String

    init(
        textInput: Binding<String>
    ) {
        self._textInput = textInput
    }

    var body: some View {
        TextFieldView(title: "Email", textInput: $textInput)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
    }
}

struct EmailTextField_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextField.init(textInput: .constant(""))
    }
}
