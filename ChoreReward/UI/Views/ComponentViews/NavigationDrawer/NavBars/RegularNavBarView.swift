//
//  RegularNavBarView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/5/22.
//

import SwiftUI

struct RegularNavBarView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    private let navTitle: String
    private let content: Content

    init(navTitle: String, content: () -> Content) {
        self.navTitle = navTitle
        self.content = content()
    }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ButtonView(buttonImage: "chevron.left") {
                        dismiss()
                    }
                    Spacer()
                }

                HStack {

                    Spacer(minLength: 50)
                    Text(navTitle)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.title2)
                    Spacer(minLength: 50)

                }
            }

            .padding([.leading, .bottom, .trailing])
            .background(Color.bg.ignoresSafeArea(edges: .top))
            .foregroundColor(.fg)

            content
            Spacer(minLength: 0)
        }

    }
}

struct RegularNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        RegularNavBarView(navTitle: "RegularNavBarView") {
            VStack {
                Text("This is RegularNavBarView")
            }
        }
    }
}
