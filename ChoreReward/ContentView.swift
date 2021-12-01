//
//  ContentView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let views: Dependency.Views
    
    init(views: Dependency.Views){
        self.views = views
    }
    
    var body: some View {
        views.rootView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(views: Dependency.preview.views())
    }
}
