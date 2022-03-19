//
//  View.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import Foundation
import SwiftUI

struct NavBarTitlePrefKey: PreferenceKey{
    static func reduce(value: inout String, nextValue: () -> String) {
        print("currentValue: \(value), nextValue: \(nextValue())")
        value = nextValue()
    }
        
    static var defaultValue: String = ""
}

extension View{
    func navBarTitle(_ title: String) -> some View{
        preference(key: NavBarTitlePrefKey.self, value: title)
    }
}
