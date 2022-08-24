//
//  FilledButtonView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/22/22.
//

import SwiftUI

struct FilledButton: View {
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
            .font(StylingFont.headline)
        }
        .smallHorizontalPadding()
        .tappableFrame()
        .buttonStyle(FilledButtonStyle())
    }
}

struct FilledButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilledButton(buttonTitle: "Preview", buttonImage: "person") {}
            FilledButton(buttonImage: "person") {}
            FilledButton(buttonTitle: "Log in") {}
        }
        .previewLayout(.sizeThatFits)
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(StylingSize.largePadding)
            .frame(
                minWidth: StylingSize.tappableWidth,
                maxWidth: .infinity,
                minHeight: StylingSize.tappableHeight,
                maxHeight: StylingSize.tappableHeight
            )
            .background(Color.bg)
            .foregroundColor(.fg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 1)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
