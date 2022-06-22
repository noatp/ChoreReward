//
//  NavigationBar.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/21/22.
//

import SwiftUI

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
        navBarLayout: NavBarLayout = .smallMiddleTitle
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
                case .largeLeftTitle:
                    HStack {
                        leftItem.frame(width: 30, height: 30, alignment: .center)
                        Text(title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.title2)
                        Spacer()
                        rightItem
                    }
                case .smallMiddleTitle:
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
                                .font(.title2)
                                .opacity(opacity)
                            Spacer(minLength: 50)
                        }
                    }
                }
            }
            .padding([.leading, .bottom, .trailing])
            .background(
                Color.bg.ignoresSafeArea(edges: .top)
                    .opacity(opacity)
            )
            .foregroundColor(Color.fg)
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        let leftItem = Button {} label: {
            Image(systemName: "person")
        }

        let rightItem = Button {} label: {
            Text("LUL")
        }
        return NavigationBar(title: "Navigation Bar", leftItem: leftItem, rightItem: rightItem)
        .previewLayout(.sizeThatFits)
    }
}

enum NavBarLayout {
    case largeLeftTitle
    case smallMiddleTitle
}
