//
//  ButtonView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/8/22.
//

import SwiftUI

struct RegularButtonView: View {
    private let action: () -> Void
    private let buttonTitle: String?
    private let buttonImage: String?

    init(
        buttonTitle: String? = nil,
        buttonImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.buttonImage = buttonImage
        self.buttonTitle = buttonTitle
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let buttonImage = buttonImage {
                    Image(systemName: buttonImage)
                }
                if let buttonTitle = buttonTitle {
                    Text(buttonTitle)
                }
            }
        }
        .buttonStyle(RegularButton())
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegularButtonView(buttonTitle: "Preview", buttonImage: "person") {

            }
            RegularButtonView(buttonImage: "person") {

            }
            RegularButtonView(buttonTitle: "Log in") {

            }
        }
        .previewLayout(.sizeThatFits)
    }
}

struct RegularButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.bg)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
