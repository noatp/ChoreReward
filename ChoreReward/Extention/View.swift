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
        .background {
            Color.clear.ignoresSafeArea()
        }
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
        .background {
            Color.clear.ignoresSafeArea()
        }
    }

    func sideDrawer(
        views: Dependency.Views,
        presentedDrawer: Binding<Bool>
    ) -> some View {
        return SideDrawer(
            views: views,
            presentedDrawer: presentedDrawer,
            mainContent: {self},
            drawerContent: {EmptyView()}
        )
    }

    func smallVerticalPadding() -> some View {
        return self.padding([.vertical], 5)
    }

    func smallHorizontalPadding() -> some View {
        return self.padding([.horizontal], 5)
    }

    func tappableFrame() -> some View {
        return self.frame(
            minWidth: StylingSize.tappableWidth,
            minHeight: StylingSize.tappableHeight,
            maxHeight: StylingSize.tappableHeight
        )
    }

    func capsuleFrame(background: Color) -> some View {
        return self
            .smallHorizontalPadding()
            .smallVerticalPadding()
            .background {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundColor(background)
            }
    }
}
