//
//  NavigationBar.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/21/22.
//

import SwiftUI

// MARK: Main Implementaion

struct NavigationBar<LeftItem: View, RightItem: View>: View {
    let title: String
    let leftItem: LeftItem
    let rightItem: RightItem
    let opacity: Double
    let navBarLayout: NavBarLayout

    init (
        title: String,
        leftItem: LeftItem,
        rightItem: RightItem,
        opacity: Double = 1,
        navBarLayout: NavBarLayout = .middleTitle
    ) {
        self.title = title
        self.leftItem = leftItem
        self.rightItem = rightItem
        self.opacity = opacity
        self.navBarLayout = navBarLayout
    }

    var body: some View {
        ZStack {
            HStack {
                switch navBarLayout {
                case .leftTitle:
                    HStack(spacing: 0) {
                        leftItem
                        Text(title)
                            .font(StylingFont.mediumTitle)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.accent)
                        Spacer()
                        rightItem
                    }
                case .middleTitle:
                    ZStack {
                        HStack {
                            leftItem
                            Spacer()
                            rightItem
                        }

                        HStack {
                            Spacer(minLength: 50)

                            Text(title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.accent)
                                .font(StylingFont.largeTitle)
                                .opacity(opacity)

                            Spacer(minLength: 50)
                        }
                    }
                }
            }
            .background(
                Color.bg.ignoresSafeArea(edges: .top)
                    .opacity(opacity)
            )
            .foregroundColor(Color.fg)
        }
    }
}

// MARK: Preview

struct NavigationBar_Previews: PreviewProvider {
    static let leftItem = Button {} label: {
        RegularButton(buttonImage: "chevron.left", action: {})
    }

    static let rightItem = Button {} label: {
        RegularButton(buttonTitle: "Next", action: {})
    }
    static var previews: some View {

        return Group {
            VStack {
                Text("Preview")
            }
            .vNavBar(
                NavigationBar(
                    title: "Navigation Bar",
                    leftItem: leftItem,
                    rightItem: rightItem,
                    navBarLayout: .leftTitle
                )
            )

            VStack {
                Text("Preview")
            }
            .zNavBar(NavigationBar(title: "Navigation Bar", leftItem: leftItem, rightItem: rightItem))

        }
        .preferredColorScheme(.dark)
    }
}

// MARK: Additional functionality

enum NavBarLayout {
    case leftTitle
    case middleTitle
}
