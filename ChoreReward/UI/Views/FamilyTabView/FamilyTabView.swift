//
//  FamilyTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct FamilyTabView: View {
    @ObservedObject var familyTabViewModel: ObservableViewModel<FamilyTabState, Void>
    private var views: Dependency.Views

    init(
        familyTabViewModel: ObservableViewModel<FamilyTabState, Void>,
        views: Dependency.Views
    ) {
        self.familyTabViewModel = familyTabViewModel
        self.views = views
    }
    var body: some View {
        if familyTabViewModel.state.hasCurrentFamily {
            views.familyListView
        } else {
            views.noFamilyView
        }
    }
}

struct FamilyTabView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyTabView(
            familyTabViewModel: .init(
                staticState: .init(
                    hasCurrentFamily: false
                )
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

extension Dependency.Views {
    var familyTabView: FamilyTabView {
        return FamilyTabView(
            familyTabViewModel: ObservableViewModel(viewModel: viewModels.familyTabViewModel),
            views: self
        )
    }
}
