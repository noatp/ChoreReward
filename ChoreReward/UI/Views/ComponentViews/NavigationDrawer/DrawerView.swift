//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct DrawerView<MainContent: View, DrawerContent: View>: View {
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
                        HStack(spacing: 0) {
                            VStack {
                                drawerDismissButton
                                Spacer()
                            }
                            .padding(.horizontal)

                            Divider()

                            VStack(alignment: .leading) {
                                Spacer().frame(maxWidth: .infinity)
                                basicDrawerContent
                            }
                            .foregroundColor(.fg)
                            .padding(.horizontal)
                        }
                        .frame(width: geoProxy.size.width * 0.75)
                        .background(Color.bg.ignoresSafeArea())
                        .transition(.move(edge: .leading))
                    }
                }
            }
        }
    }
}

struct SideDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView<Text, EmptyView>(
            views: Dependency.preview.views(), presentedDrawer: .constant(false)
        ) {
            Text("This is a Preview of NavDrawerView")
        } drawerContent: {
            EmptyView()
        }
    }
}

extension DrawerView {
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
        RegularButtonView(buttonImage: "xmark", action: {
            withAnimation {
                presentedDrawer = false
            }
        })
    }

    private var basicDrawerContent: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                views.userGoalView
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                    Text("Your Reward")
                }
            }
            // .buttonStyle(.plain)
            .padding([.horizontal, .top])

            NavigationLink {
                views.userProfileView
            } label: {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Your Profile")
                }
            }
            // .buttonStyle(.plain)
            .padding([.horizontal, .top])

            RegularButtonView(buttonTitle: "Settings", buttonImage: "gearshape") {

            }
            .padding([.horizontal, .top])
        }
    }

}
