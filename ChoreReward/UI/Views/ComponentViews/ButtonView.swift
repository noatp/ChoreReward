//
//  ButtonView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/8/22.
//

import SwiftUI

struct ButtonView: View {
    private var action: () -> Void
    private var buttonTitle: String?
    private var buttonImage: String?
    
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
            HStack{
                if let buttonImage = buttonImage {
                    Image(systemName: buttonImage)
                }
                if let buttonTitle = buttonTitle {
                    Text(buttonTitle)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ButtonView(buttonTitle: "Preview", buttonImage: "person") {
                
            }
            ButtonView(buttonImage: "person") {
                
            }
            ButtonView(buttonTitle: "Preview") {
                
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
