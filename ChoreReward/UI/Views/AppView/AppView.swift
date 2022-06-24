//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

// MARK: Main Implementaion

struct AppView: View {
    @ObservedObject var appViewModel: ObservableViewModel<AppViewState, Void>
    @State var selectedTab: Tabs = .choreTab
    @State var presentingAddChoreView: Bool = false
    private var views: Dependency.Views

    init(
        appViewModel: ObservableViewModel<AppViewState, Void>,
        views: Dependency.Views
    ) {
        self.appViewModel = appViewModel
        self.views = views
    }

    var body: some View {
        if appViewModel.state.shouldPresentNoFamilyView {
            views.noFamilyView
        } else {
            NavigationView {
                views.navDrawerView(navTitle: selectedTab.rawValue) {
                    mainContent
                } drawerContent: {
                    drawerContent
                }
            }
            .padding(.vertical)
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $presentingAddChoreView) {
                views.addChoreView()
            }

        }
    }
}

// MARK: Preview

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            appViewModel: .init(staticState: .empty),
            views: Dependency.preview.views()
        )
        .font(StylingFont.regular)
        .preferredColorScheme(.light)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var appView: AppView {
        return AppView(
            appViewModel: ObservableViewModel(viewModel: viewModels.appViewModel),
            views: self
        )
    }
}

// MARK: Subviews

extension AppView {
    var mainContent: some View {
        VStack {
            // main view
            switch selectedTab {
            case .choreTab:
                views.choreTabView()
            case .familyTab:
                views.familyTabView
            }
            Spacer(minLength: 0)
            // tab bar
            tabBar
        }
    }

    var drawerContent: some View {
        VStack {
            switch selectedTab {
            case .choreTab:
                ChoreTabDrawerView()
            case .familyTab:
                FamilyTabDrawerView()
            }
            Spacer(minLength: 0)
        }
    }

    var tabBar: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .choreTab
            } label: {
                VStack {
                    Image(systemName: (selectedTab == .choreTab ? "checkmark.seal.fill" : "checkmark.seal"))
                    Text("Chores")
                        .font(StylingFont.medium)
                }
            }
            .foregroundColor(selectedTab == .choreTab ? Color.accLight : Color.accDark)
            // .buttonStyle(.plain)
            Spacer()

            if appViewModel.state.shouldRenderAddChoreButton {
                Button {
                    presentingAddChoreView = true
                } label: {
                    VStack {
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 40, weight: .bold))
                        Text("New Chore")
                            .font(StylingFont.medium)
                    }
                }
                .foregroundColor(.acc)
            }

            Spacer()
            Button {
                selectedTab = .familyTab
            } label: {
                VStack {
                    Image(systemName: (selectedTab == .familyTab ? "house.fill" : "house"))
                    Text("Family")
                        .font(StylingFont.medium)
                }
            }
            .foregroundColor(selectedTab == .familyTab ? Color.accLight : Color.accDark)
            Spacer()
        }
        .overlay(Divider(), alignment: .top)
    }
}

// MARK: Additional functionality

extension AppView {
    enum Tabs: String {
        case choreTab = "Chores"
        case familyTab = "Family Members"
    }
}
