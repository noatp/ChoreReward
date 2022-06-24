//
//  TextEditorView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/24/22.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var textInput: String
    private var title: String

    init(
        title: String,
        textInput: Binding<String>
    ) {
        self.title = title
        self._textInput = textInput
    }

    var body: some View {
        ZStack {
            TextEditor(text: $textInput)
                .padding([.horizontal], 11)
                .cornerRadius(12)

            if textInput.isEmpty {
                VStack {
                    HStack {
                        Text(title)
                            .padding([.leading], 15)
                            .padding([.top], 10)
                            .foregroundColor(.textFieldPlaceholder)
                        Spacer()
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
        .frame(height: 200)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray)
                .shadow(radius: 1)
        }
        .smallVerticalPadding()
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(title: "Description", textInput: .constant(""))
            .previewLayout(.sizeThatFits)
            .font(StylingFont.regular)
    }
}
