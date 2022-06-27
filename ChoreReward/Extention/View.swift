//
//  View.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import Foundation
import SwiftUI

extension View {
    func scrollViewOffset(_ offset: Binding<Double>) -> some View {
        background(GeometryReader { geoProxy -> Color in
            let scrollViewOffset = geoProxy.frame(in: .global).minY / -100
            DispatchQueue.main.async {
                offset.wrappedValue = scrollViewOffset
            }
            return Color.clear
        })
    }

    func vNavBar<LeftItem: View, RightItem: View>(_ navBarContent: NavigationBar<LeftItem, RightItem>) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            navBarContent
            self
            Spacer(minLength: 0)
        }
        .navigationBarHidden(true)
    }

    func zNavBar<LeftItem: View, RightItem: View>(_ navBarContent: NavigationBar<LeftItem, RightItem>) -> some View {
        return ZStack {
            self
            VStack {
                navBarContent
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    func sideDrawer(
        views: Dependency.Views,
        presentedDrawer: Binding<Bool>
    ) -> some View {
        return DrawerView(
            views: views,
            presentedDrawer: presentedDrawer,
            mainContent: {self},
            drawerContent: {EmptyView()}
        )
    }

    func smallVerticalPadding() -> some View {
        return self.padding([.vertical], 5)
    }
}
