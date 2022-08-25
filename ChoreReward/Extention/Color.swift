//
//  Color.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/16/22.
//

import Foundation
import SwiftUI

extension Color {
    static let bg = Color(light: .white, dark: .black)
    static let fg = Color(light: .black, dark: .white)
    static let altFg = Color(light: .white, dark: .white)
    static let fgGray = Color(light: .gray2, dark: .gray1)
    static let accent = Color(light: orange3, dark: orange1)
    static let pickerAccent = Color(light: white, dark: .gray3)
    static let pickerBg = Color(light: .orange4, dark: .gray5)
    static let pickerFgActive = Color(light: orange3, dark: .white)
    static let border = Color(light: .orange4, dark: .gray5)
    static let navBarFg = Color(light: .white, dark: .orange1)

    static let matchingBtnBg = Color(light: .orange2, dark: .gray4)
    static let contrastBtnBg = Color(light: .white, dark: .gray3)

    static let navBarBg = Color(light: .orange2, dark: .gray4)
    static let tabBarBg = Color(light: .white, dark: .gray4)
    static let progressBarBg = Color(light: .gray2, dark: .gray1)
    static let toolbarBg = Color(light: .orange2, dark: .gray4)

    static let sideDrawerBg = Color(light: .white, dark: .gray4)
    static let sideDrawerDismissBtn = Color(light: .white, dark: .gray4)

    static let orange1 = StylingColor.orange1
    static let orange2 = StylingColor.orange2
    static let orange3 = StylingColor.orange3
    static let orange4 = StylingColor.orange4
    static let orange5 = StylingColor.orange5

    static let gray1 = StylingColor.gray1
    static let gray2 = StylingColor.gray2
    static let gray3 = StylingColor.gray3
    static let gray4 = StylingColor.gray4
    static let gray5 = StylingColor.gray5
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return light
            case .dark:
                return dark
            @unknown default:
                return light
            }
        }
    }
}

extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}
