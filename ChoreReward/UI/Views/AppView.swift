//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

// MARK: Main Implementaion

struct AppView: View {
    @ObservedObject var appViewModel: ObservableViewModel<AppViewState, AppViewAction>
    @State var selectedTab: Tabs = .choreTab
    @State var presentingAddChoreView: Bool = false
    @State var presentedDrawer: Bool = false

    private var views: Dependency.Views

    init(
        appViewModel: ObservableViewModel<AppViewState, AppViewAction>,
        views: Dependency.Views
    ) {
        self.appViewModel = appViewModel
        self.views = views
    }

    var body: some View {
        UnwrapViewState(viewState: appViewModel.viewState) { viewState in
            NavigationView {
                if viewState.shouldPresentNoFamilyView {
                    views.noFamilyView
                        .navigationBarHidden(true)
                } else {
                    VStack {
                        // main view
                        switch selectedTab {
                        case .choreTab:
                            views.choreTabView(presentedDrawer: $presentedDrawer)
                        case .familyTab:
                            views.familyTabView(presentedDrawer: $presentedDrawer)
                        }

                        Spacer(minLength: 0)
                        // tab bar
                        tabBar
                    }
                    .sideDrawer(views: views, presentedDrawer: $presentedDrawer)
                    .fullScreenCover(isPresented: $presentingAddChoreView) {
                        views.addChoreView()
                    }
                    .navigationBarHidden(true)
                    .fullScreenCover(isPresented: Binding<Bool>(
                        get: {
                            viewState.shouldNavigateToDeepLink
                        },
                        set: { newState in
                            appViewModel.perform(
                                action: .updateShouldShouldNavigateToNotificationState(newState: newState)
                            )
                        }
                    )) {
                        switch viewState.deepLinkTarget {
                        case .none:
                            ProgressView()
                        case .detail(let choreId):
                            views.choreDetailView(choreId: choreId)
                        }
                    }
                }
            }
        }
        .onOpenURL { url in
            appViewModel.perform(action: .parseUrlToDeepLinkTarget(url))
        }
    }
}

// MARK: Preview

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            appViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )
        .font(StylingFont.regular)
        .preferredColorScheme(.dark)
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

    var tabBar: some View {
        UnwrapViewState(viewState: appViewModel.viewState) { viewState in
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
                .foregroundColor(selectedTab == .choreTab ? Color.accent : Color.accentGray)
                Spacer()

                if viewState.shouldRenderAddChoreButton {
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
                    .foregroundColor(.accent)
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
                .foregroundColor(selectedTab == .familyTab ? Color.accent : Color.accentGray)
                Spacer()
            }
            .background {
                Color.bg.ignoresSafeArea()
            }
        }
    }
}

// MARK: Additional functionality

extension AppView {
    enum Tabs: String {
        case choreTab = "Chores"
        case familyTab = "Family Members"
    }
}
