//
//  CustomProgressBar.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/29/22.
//

import SwiftUI

struct CustomProgressBar: View {
    @State private var progress: Int

    init(progress: Int) {
        self.progress = progress
    }

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 12)
                    .shadow(color: .progressBarBg, radius: 1, x: 0, y: 0)
                    .foregroundColor(.bg)
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.accent)
                    .frame(width: proxy.size.width / 100 * CGFloat(Float(progress)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 15)
    }
}

struct CustomProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressBar(progress: 50)

        CustomProgressBar(progress: 50)
            .preferredColorScheme(.dark)

    }
}
