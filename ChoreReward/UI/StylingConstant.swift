//
//  StylingConstant.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/23/22.
//

import Foundation
import SwiftUI

struct StylingFont {
    static let small: Font = .system(size: 12, weight: .light, design: .rounded)
    static let medium: Font = .system(size: 15, weight: .medium, design: .rounded)
    static let regular: Font = .system(size: 18, weight: .regular, design: .rounded)
    static let large: Font = .system(size: 20, weight: .semibold, design: .rounded)
    static let title: Font = .system(size: 30, weight: .bold, design: .rounded)
}

struct StylingSize {
    static let tappableWidth: CGFloat = 44
    static let tappableHeight: CGFloat = 44
}
