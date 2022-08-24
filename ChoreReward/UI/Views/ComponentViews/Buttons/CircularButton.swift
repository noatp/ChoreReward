//
//  CircularButton.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/25/22.
//

import SwiftUI

// MARK: Main Implementaion

struct CircularButton: View {
    let action: () -> Void
    let icon: String

    init(action: @escaping () -> Void, icon: String) {
        self.action = action
        self.icon = icon
    }

    var body: some View {
        CustomizableRegularButton {
            Image(systemName: icon)
                .font(StylingFont.icon)
                .tappableFrame()
                .background {
                    Color.bg.clipShape(Circle())
                }
        } action: {
            action()
        }
        .tappableFrame()

    }
}

// MARK: Preview

struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton(action: {}, icon: "xmark")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
