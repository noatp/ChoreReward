//
//  RootView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootViewModel: ObservableViewModel<RootViewState, Void>

    private var views: Dependency.Views

    init(
        rootViewModel: ObservableViewModel<RootViewState, Void>,
        views: Dependency.Views
    ) {
        self.views = views
        self.rootViewModel = rootViewModel
    }

    var body: some View {
        UnwrapViewState(viewState: rootViewModel.viewState) { viewState in
            ZStack {
                if viewState.shouldRenderLoginView {
                    views.loginView
                } else {
                    views.appView
                }
            }
        }

    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            rootViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )
    }
}

extension Dependency.Views {
    var rootView: RootView {
        return RootView(
            rootViewModel: ObservableViewModel(viewModel: viewModels.rootViewModel),
            views: self
        )
    }
}
