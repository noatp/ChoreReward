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
//        NavDrawerView(navTitle: selectedTab.rawValue){
//            NavigationView{
//                TabView(selection: $selectedTab) {
//                    views.choreTabView()
//                        .navigationBarHidden(true)
//                        .tabItem {
//                            Image(systemName: "checkmark.seal.fill")
//                            Text("Chore")
//                        }
//                        .tag(Tabs.choreTab)
//
//                    views.familyTabView
//                        .navigationBarHidden(true)
//                        .tabItem {
//                            Image(systemName: "house")
//                            Text("Family")
//                        }
//                        .tag(Tabs.familyTab)
//
//                    views.userTabView
//                        .navigationBarHidden(true)
//                        .tabItem {
//                            Image(systemName: "person.crop.circle")
//                            Text("Profile")
//                        }
//                        .tag(Tabs.userTab)
//                }
//                .font(.headline)
//                .navigationTitle(selectedTab.rawValue)
//            }
//        }
        NavigationView{
            VStack{
                switch selectedTab {
                case .choreTab:
                    views.choreTabView()
                case .familyTab:
                    views.familyTabView
                case .userTab:
                    views.userTabView
                }
                Spacer(minLength: 0)
                HStack{
                    Spacer()
                    Button {
                        selectedTab = .choreTab
                    } label: {
                        VStack {
                            Image(systemName: (selectedTab == .choreTab ? "checkmark.seal.fill" : "checkmark.seal"))
                            Text("Chores")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        .foregroundColor(selectedTab == .choreTab ? Color.accLight : Color.accDark)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "plus.app.fill")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.acc)
                            Text("New Chore")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                    }
                    Spacer()
                    Button {
                        selectedTab = .familyTab
                    } label: {
                        VStack {
                            Image(systemName: (selectedTab == .familyTab ? "house.fill" : "house"))
                            Text("Family")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        .foregroundColor(selectedTab == .familyTab ? Color.accLight : Color.accDark)
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .padding(.vertical)
        .ignoresSafeArea()
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            appViewModel: .init(staticState: ()),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.light)
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
