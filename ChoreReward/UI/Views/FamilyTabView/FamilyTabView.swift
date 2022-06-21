//
//  FamilyListView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI

struct FamilyTabView: View {
    @ObservedObject var familyTabViewModel: ObservableViewModel<FamilyTabState, Void>
    @State var presentedSheet = false
    private var views: Dependency.Views

    init(
        familyTabViewModel: ObservableViewModel<FamilyTabState, Void>,
        views: Dependency.Views
    ) {
        self.familyTabViewModel = familyTabViewModel
        self.views = views
    }

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(familyTabViewModel.state.members) { member in
                    UserCardView(user: member)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if familyTabViewModel.state.shouldRenderAddMemberButton {
                        CircularButton(action: {
                            presentedSheet = true
                        }, icon: "plus")
                        .padding()
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $presentedSheet) {
            views.addFamilyMemberView()
        }
    }
}

struct FamilyListView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyTabView(
            familyTabViewModel: .init(
                staticState: .init(
                    members: [DenormUser.preview],
                    shouldRenderAddMemberButton: true
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
