//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    init(dependency: Dependency = .preview){
        self.appViewModel = dependency.appViewModel
    }
    
    var body: some View {
        NavigationView {
            LoginView(dependency: Dependency.shared)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
