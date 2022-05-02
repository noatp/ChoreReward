//
//  CircularButton.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/25/22.
//

import SwiftUI

struct CircularButton: View {
    let action: () -> Void
    let icon: String
    
    init(action: @escaping () -> Void, icon: String) {
        self.action = action
        self.icon = icon
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.fg)
                .background(Color.bg)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton(action: {}, icon: "xmark")
            .previewLayout(.sizeThatFits)
    }
}
