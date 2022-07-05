//
//  SecuredTextField.swift
//  ChoreReward
//
//  Created by Toan Pham on 7/4/22.
//

import SwiftUI

struct SecuredTextField: View {

    @Binding private var textInput: String
    private var title: String

    init(
        title: String,
        textInput: Binding<String>
    ) {
        self.title = title
        self._textInput = textInput
    }

    var body: some View {
        SecureField(title, text: $textInput)
    }
}

struct SecuredTextField_Previews: PreviewProvider {
    static var previews: some View {
        SecuredTextField(title: "Password", textInput: .constant(""))
    }
}
