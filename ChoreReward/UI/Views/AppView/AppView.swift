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
            NavigationView{
                views.choreTabView
            }
            .tabItem {
                Image(systemName: "checkmark.seal.fill")
                Text("Chore")
            }
            .navigationViewStyle(.automatic)

            
            NavigationView{
                views.familyTabView
            }
            .tabItem {
                Image(systemName: "house")
                Text("Family")
            }
            .navigationViewStyle(.automatic)

            
            NavigationView{
                views.userTabView
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
            .navigationViewStyle(.automatic)
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
