//
//  RootView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootViewModel: RootViewModel
    
    init(dependency: Dependency = .preview) {
        self.rootViewModel = dependency.rootViewModel
    }
    
    var body: some View {
        NavigationView{
            if (rootViewModel.shouldRenderLoginView){
                LoginView(dependency: Dependency.shared)
            }
            else{
                AppView(dependency: Dependency.shared)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
