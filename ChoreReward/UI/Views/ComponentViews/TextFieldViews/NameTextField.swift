//
//  nameTextField.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/22/22.
//

import SwiftUI

struct NameTextField: View {
    @Binding var textInput: String

    init(
        textInput: Binding<String>
    ) {
        self._textInput = textInput
    }

    var body: some View {
        TextFieldView(title: "Name", textInput: $textInput)
            .textContentType(.name)
            .keyboardType(.namePhonePad)
    }
}

struct NameTextField_Previews: PreviewProvider {
    static var previews: some View {
        NameTextField.init(textInput: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
