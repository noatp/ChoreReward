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
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
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
                    ZStack {
                        // main view
                        switch selectedTab {
                        case .choreTab:
                            views.choreTabView(presentedDrawer: $presentedDrawer)
                        case .familyTab:
                            views.familyTabView(presentedDrawer: $presentedDrawer)
                        }
                        VStack {
                            Spacer()
                            tabBar
                        }
                    }
                    .sideDrawer(views: views, presentedDrawer: $presentedDrawer)
                    .fullScreenCover(isPresented: $presentingAddChoreView) {
                        views.addChoreView()
                    }
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
                        case .addMember:
                            views.addFamilyMemberView()
                        }
                    }
                    .onAppear {
                        if isFirstLaunch {
                            isFirstLaunch = false
                            if viewState.shouldShowAddMemberOnFirstLaunch {
                                selectedTab = .familyTab
                                var components = URLComponents()
                                components.scheme = "chorereward"
                                components.host = "com.noatp.chorereward"
                                components.path = "/addMember"
                                guard let url = components.url else {
                                    return
                                }

                                print("\(#fileID) \(#function): opening url \(url)")

                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
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
        .preferredColorScheme(.dark)

        AppView(
            appViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )
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
            ZStack(alignment: .bottom) {
                HStack(alignment: .bottom, spacing: .zero) {
                    Spacer()
                    CustomizableRegularButton {
                        VStack(spacing: .zero) {
                            Image(systemName: (selectedTab == .choreTab ? "checkmark.seal.fill" : "checkmark.seal"))
                                .font(StylingFont.icon)
                                .smallVerticalPadding()
                            Text("Chores")
                                .font(StylingFont.caption)
                        }
                    } action: {
                        selectedTab = .choreTab
                    }
                    .foregroundColor(selectedTab == .choreTab ? Color.accent : Color.fgGray)
                    Spacer()
                    Spacer()
                    Spacer()
                    CustomizableRegularButton {
                        VStack(spacing: .zero) {
                            Image(systemName: (selectedTab == .familyTab ? "house.fill" : "house"))
                                .font(StylingFont.icon)
                                .smallVerticalPadding()
                            Text("Family")
                                .font(StylingFont.caption)
                        }
                    } action: {
                        selectedTab = .familyTab

                    }
                    .foregroundColor(selectedTab == .familyTab ? Color.accent : Color.fgGray)
                    Spacer()
                }
                .background(.thickMaterial)

                if viewState.shouldRenderAddChoreButton {
                    CustomizableRegularButton {
                        VStack(spacing: .zero) {
                            Image(systemName: "plus")
                                .font(StylingFont.icon)
                                .tappableFrame()
                                .smallVerticalPadding()
                                .background {
                                    Color.accent.clipShape(Circle())
                                }
                                .foregroundColor(.tabBarBg)
                                .smallVerticalPadding()
                            Text("New Chore")
                                .font(StylingFont.caption)

                        }
                    } action: {
                        presentingAddChoreView = true
                    }
                    .foregroundColor(.accent)

                }

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
