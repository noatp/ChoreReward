//
//  ButtonView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/8/22.
//

import SwiftUI

struct ButtonView: View {
    private var action: () -> Void
    private var buttonTitle: String
    private var buttonImage: String
    private var buttonColor: Color
    
    init(
        action: @escaping () -> Void,
        buttonTitle: String,
        buttonImage: String,
        buttonColor: Color
    ) {
        self.action = action
        self.buttonImage = buttonImage
        self.buttonTitle = buttonTitle
        self.buttonColor = buttonColor
    }
    
    var body: some View {
        Button(action: action) {
            Label(buttonTitle, systemImage: buttonImage)
                .foregroundColor(buttonColor)
        }
        .padding()
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(action: {}, buttonTitle: "Preview Button", buttonImage: "person", buttonColor: Color.blue)
            .previewLayout(.sizeThatFits)
    }
}
