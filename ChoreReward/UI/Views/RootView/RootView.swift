//
//  RootView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootViewModel: RootViewModel
    
    private var views: Dependency.Views
    
    init(
        views: Dependency.Views,
        rootViewModel: RootViewModel
    ) {
        self.views = views
        self.rootViewModel = rootViewModel
    }
    
    var body: some View {
        if (rootViewModel.shouldRenderLoginView){
            views.loginView
        }
        else{
            views.appView
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().rootView
    }
}

extension Dependency.Views{
    var rootView: RootView{
        return RootView(views: self, rootViewModel: viewModels.rootViewModel)
    }
}
