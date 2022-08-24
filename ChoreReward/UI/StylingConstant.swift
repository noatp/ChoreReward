//
//  StylingConstant.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/23/22.
//

import Foundation
import SwiftUI

struct StylingFont {
    // for new chore button on tab bar
    static let extraLargeIcon: Font = .system(size: 50, weight: .regular, design: .rounded)

    // for other tab bar button
    static let icon: Font = .system(size: 22, weight: .regular, design: .default)

    // for centered nav title, chore title in chore detail
    static let largeTitle: Font = .system(size: 34, weight: .semibold, design: .rounded)

    // for offset nav title, reward in chore detail
    static let mediumTitle: Font = .system(size: 28, weight: .bold, design: .rounded)

    //
    static let smallTitle: Font = .system(size: 22, weight: .bold, design: .rounded)

    // for buttons
    static let headline: Font = .system(size: 17, weight: .semibold, design: .rounded)

    //
    static let body: Font = .system(size: 17, weight: .regular, design: .rounded)

    //
    static let callout: Font = .system(size: 16, weight: .regular, design: .rounded)

    //
    static let subhead: Font = .system(size: 15, weight: .regular, design: .rounded)

    //
    static let footnote: Font = .system(size: 13, weight: .regular, design: .rounded)

    //
    static let caption: Font = .system(size: 11, weight: .light, design: .rounded)
}

struct StylingSize {
    static let tappableWidth: CGFloat = 44
    static let tappableHeight: CGFloat = 44
    static let smallPadding: CGFloat = 5
    static let mediumPadding: CGFloat = 10
    static let largePadding: CGFloat = 15
}

struct TestFontSizeView: View {
    var body: some View {
        VStack {
            Text("Large Title")
                .font(StylingFont.largeTitle)
            Text("Medium Title")
                .font(StylingFont.mediumTitle)
            Text("Small Title")
                .font(StylingFont.smallTitle)
            Text("Headline Headline")
                .font(StylingFont.headline)
            Text("Body Body")
                .font(StylingFont.body)
            Text("Callout Callout")
                .font(StylingFont.callout)
            Text("Subhead Subhead")
                .font(StylingFont.subhead)
            Text("Footnote Footnote")
                .font(StylingFont.footnote)
            Text("Caption Caption")
                .font(StylingFont.caption)
        }
    }
}

struct TestFontSizeView_Previews: PreviewProvider {
    static var previews: some View {
        TestFontSizeView()
    }
}
