//
//  View.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import Foundation
import SwiftUI

extension View{
    func scrollViewOffset(_ offset: Binding<Double>) -> some View{
        background(GeometryReader { geoProxy -> Color in
            let scrollViewOffset = geoProxy.frame(in: .global).minY / -100
            DispatchQueue.main.async {
                offset.wrappedValue = scrollViewOffset
            }
            return Color.clear
        })
    }
}
