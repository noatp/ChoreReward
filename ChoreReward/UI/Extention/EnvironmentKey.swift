//
//  EnvironmentKey.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/25/22.
//

import Foundation
import SwiftUI

struct PresentingSideDrawer: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
  var presentingSideDrawer: Binding<Bool> {
    get { self[PresentingSideDrawer.self] }
    set { self[PresentingSideDrawer.self] = newValue }
  }
}
