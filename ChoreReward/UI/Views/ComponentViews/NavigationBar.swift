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
                    HStack {
                        leftItem.frame(width: 30, height: 30, alignment: .center)
                        Text(title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.system(size: 25, weight: .bold, design: .rounded))
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
                                .font(.system(size: 25, weight: .semibold, design: .rounded))
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
            Image(systemName: "chevron.left")
        }

        let rightItem = Button {} label: {
            Text("Next")
        }
        return Group {
            NavigationBar(title: "Navigation Bar", leftItem: leftItem, rightItem: rightItem)
            NavigationBar(title: "Navigation Bar", leftItem: leftItem, rightItem: rightItem, navBarLayout: .leftTitle)
        }
        .previewLayout(.sizeThatFits)
    }
}

enum NavBarLayout {
    case leftTitle
    case middleTitle
}
