//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct SideDrawer<MainContent: View, DrawerContent: View>: View {
    @Binding private var presentedDrawer: Bool

    private var views: Dependency.Views
    private let mainContent: MainContent
    private let drawerContent: DrawerContent

    init(
        views: Dependency.Views,
        presentedDrawer: Binding<Bool>,
        mainContent: () -> MainContent,
        drawerContent: () -> DrawerContent
    ) {
        self.views = views
        self._presentedDrawer = presentedDrawer
        self.mainContent = mainContent()
        self.drawerContent = drawerContent()
    }

    var body: some View {
        ZStack {
            mainContent

            // side drawer content
            GeometryReader { geoProxy in
                ZStack(alignment: .leading) {
                    // transparent layer to prevent interaction with main content
                    if presentedDrawer {
                        transparentBackground

                        // side menu
                        HStack(alignment: .top, spacing: .zero) {
                            VStack(alignment: .leading, spacing: .zero) {
                                drawerDismissButton
                                Spacer()
                            }

                            Divider()

                            VStack(alignment: .leading, spacing: .zero) {
                                basicDrawerContent
                                Spacer()
                            }
                            .padding(.horizontal)

                            Spacer()

                            Color.gray7
                                .ignoresSafeArea()
                                .frame(maxWidth: 2)
                        }
                        .frame(width: geoProxy.size.width * 0.75)
                        .background(
                            Color.bg
                        )
                        .transition(.move(edge: .leading))
                    }
                }
            }

        }
    }
}

struct SideDrawerView_Previews: PreviewProvider {
    static let leftItem = Button {} label: {
        RegularButton(buttonImage: "line.3.horizontal", action: {})
    }

    static let rightItem = Button {} label: {
        RegularButton(buttonTitle: "Next", action: {})
    }
    static var previews: some View {
        VStack {
            Text("This is a Preview of NavDrawerView")
        }
        .padding()
        .vNavBar(
            NavigationBar(
                title: "Navigation Bar",
                leftItem: leftItem,
                rightItem: rightItem,
                navBarLayout: .leftTitle
            )
        )
        .sideDrawer(views: Dependency.preview.views(), presentedDrawer: .constant(true))
        .preferredColorScheme(.dark)

        VStack {
            Text("This is a Preview of NavDrawerView")
        }
        .padding()
        .vNavBar(
            NavigationBar(
                title: "Navigation Bar",
                leftItem: leftItem,
                rightItem: rightItem,
                navBarLayout: .leftTitle
            )
        )
        .sideDrawer(views: Dependency.preview.views(), presentedDrawer: .constant(true))
        .preferredColorScheme(.light)
    }
}

extension SideDrawer {
    private var transparentBackground: some View {
        Color.bg.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.spring()) {
                    presentedDrawer = false
                }
            }
            .transition(.opacity)
    }

    private var drawerDismissButton: some View {
        CircularButton(action: {
            withAnimation {
                presentedDrawer = false
            }
        }, icon: "xmark")
    }

    private var basicDrawerContent: some View {
        VStack(alignment: .leading, spacing: .zero) {
            NavigationLink {
                views.userGoalView
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                    Text("Your Reward")
                }
            }
            .tappableFrame()

            NavigationLink {
                views.userProfileView
            } label: {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Your Profile")
                }
            }
            .tappableFrame()

        }
        .font(StylingFont.headline)
        .foregroundColor(.fg)
    }

}
