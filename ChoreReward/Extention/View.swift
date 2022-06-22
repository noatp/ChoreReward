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

    func vNavBar<NavBarContent: View>(_ navBarContent: NavBarContent) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            navBarContent
            self
            Spacer(minLength: 0)
        }
        .navigationBarHidden(true)
    }

    func zNavBar<NavBarContent: View>(_ navBarContent: NavBarContent) -> some View {
        return ZStack {
            self
            VStack {
                navBarContent
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    func smallVerticalPadding() -> some View {
        return self.padding([.vertical], 5)
    }
}
