//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var appViewModel: AppViewModel
    private var views: Dependency.Views
    
    init(
        appViewModel: AppViewModel,
        views: Dependency.Views
    ){
        self.appViewModel = appViewModel
        self.views = views
    }
    
    var body: some View {
        TabView {
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            views.userTabView
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("User Profile")
                }
        }
        .font(.headline)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().appView
    }
}

extension Dependency.Views{
    var appView: AppView{
        return AppView(
            appViewModel: viewModels.appViewModel,
            views: self
        )
    }
}
