//
//  FreeFormRegularButton.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/27/22.
//

import SwiftUI

struct CustomizableRegularButton<LabelContent: View>: View {
    private let action: () -> Void
    private let label: LabelContent

    init(
        label: () -> LabelContent,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button {
            action()
        } label: {
            label
        }
        .font(StylingFont.headline)
        .smallHorizontalPadding()
//        .tappableFrame()
    }
}

struct CustomizableRegularButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomizableRegularButton {
                Text("Click me!")
            } action: {}
        }
        .background(Color.bg)
        .previewLayout(.sizeThatFits)
    }
}
