//
//  RegularTextField.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/28/22.
//

import SwiftUI

struct RegularTextField: View {

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
        TextField(title, text: $textInput)
    }
}

struct RegularTextField_Previews: PreviewProvider {
    static var previews: some View {
        RegularTextField(title: "Preview", textInput: .constant(""))
    }
}
