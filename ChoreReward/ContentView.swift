//
//  ContentView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        RootView(dependency: Dependency.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
