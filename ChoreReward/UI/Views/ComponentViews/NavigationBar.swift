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
                    HStack(alignment: .center, spacing: .zero) {
                        leftItem
                        Text(title)
                            .font(StylingFont.mediumTitle)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.accent)
                        Spacer()
                        rightItem
                    }
                    .tappableFrame()

                case .middleTitle:
                    ZStack(alignment: .center) {
                        HStack(alignment: .center, spacing: .zero) {
                            leftItem
                            Spacer()
                            rightItem
                        }
                        .tappableFrame()

                        HStack(alignment: .center, spacing: .zero) {
                            Spacer(minLength: StylingSize.tappableWidth)

                            Text(title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.accent)
                                .font(StylingFont.largeTitle)
                                .opacity(opacity)

                            Spacer(minLength: StylingSize.tappableWidth)
                        }
                        .tappableFrame()
                    }
                }
            }
            .padding(.bottom, StylingSize.smallPadding)
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
        CircularButton(action: {}, icon: "line.3.horizontal")
    }

    static let rightItem = Button {} label: {
        CircularButton(action: {}, icon: "checkmark")
    }
    static var previews: some View {

        return Group {
            VStack {
                Text("Preview")
            }
            .vNavBar(
                NavigationBar(
                    title: "Navigation Bar Extra Long",
                    leftItem: leftItem,
                    rightItem: rightItem
                )
            )

            VStack {
                Text("Preview")
            }
            .vNavBar(
                NavigationBar(
                    title: "Navigation Bar Extra Long",
                    leftItem: leftItem,
                    rightItem: EmptyView(),
                    navBarLayout: .leftTitle
                )
            )

            VStack {
                Text("Preview")
            }
            .zNavBar(
                NavigationBar(
                    title: "Navigation Bar",
                    leftItem: leftItem,
                    rightItem: rightItem
                )
            )

        }
        .preferredColorScheme(.dark)
    }
}

// MARK: Additional functionality

enum NavBarLayout {
    case leftTitle
    case middleTitle
}
