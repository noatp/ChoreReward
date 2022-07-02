//
//  TextFieldView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import SwiftUI

struct CustomTextField: View {

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
        ZStack {
            Group {
                if secured {
                    SecureField(text: $textInput) {}
                } else {
                    TextField(text: $textInput) {}
                }
            }
            .textFieldStyle(PlainTextFieldStyle())
            .padding([.horizontal], 15)
            .cornerRadius(12)
            .autocapitalization(UITextAutocapitalizationType.none)
            .disableAutocorrection(true)

            if textInput.isEmpty {
                VStack {
                    HStack {
                        Text(title)
                            .padding([.leading], 15)
                            .padding([.top], 12)
                            .foregroundColor(.accentGraySecondary)
                        Spacer()
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
        .tappableFrame()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray)
                .shadow(radius: 1)
        }
        .smallVerticalPadding()
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextField(title: "Password", textInput: .constant(""), secured: true)
            CustomTextField(title: "Name", textInput: .constant(""))
        }
        .previewLayout(.sizeThatFits)
    }
}
