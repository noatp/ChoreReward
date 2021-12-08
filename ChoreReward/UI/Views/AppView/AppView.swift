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
            views.choreTabView
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Chore")
                }
            views.familyTabView
                .tabItem {
                    Image(systemName: "house")
                    Text("Family")
                }
            views.userTabView
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
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
