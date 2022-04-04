//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

enum Tabs: String{
    case choreTab = "Chores"
    case familyTab = "Family Members"
    case userTab = "Your Profile"
}

struct AppView: View {
    @ObservedObject var appViewModel: ObservableViewModel<Void, Void>
    @State var selectedTab: Tabs = .choreTab
    @State var presentingSideDrawer: Bool = false
    private var views: Dependency.Views
    
    init(
        appViewModel: ObservableViewModel<Void, Void>,
        views: Dependency.Views
    ){
        self.appViewModel = appViewModel
        self.views = views
    }
    
    var body: some View {
        SideDrawerView{
            NavigationView{
                TabView(selection: $selectedTab) {
                    views.choreTabView()
                        .navigationBarHidden(true)
                        .tabItem {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Chore")
                        }
                        .tag(Tabs.choreTab)

                    views.familyTabView
                        .navigationBarHidden(true)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Family")
                        }
                        .tag(Tabs.familyTab)
     
                    views.userTabView
                        .navigationBarHidden(true)
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                        .tag(Tabs.userTab)
                }
                .font(.headline)
                .navigationTitle(selectedTab.rawValue)
            }
        }
        .environment(\.presentingSideDrawer, $presentingSideDrawer)
    }
        
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            appViewModel: .init(staticState: ()),
            views: Dependency.preview.views()
        )
    }
}

extension Dependency.Views{
    var appView: AppView{
        return AppView(
            appViewModel: ObservableViewModel(viewModel: viewModels.appViewModel),
            views: self
        )
    }
}
