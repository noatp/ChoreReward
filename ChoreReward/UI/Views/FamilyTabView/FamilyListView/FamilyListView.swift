//
//  FamilyListView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI

struct FamilyListView: View {
    @ObservedObject var familyListViewModel: ObservableViewModel<FamilyListState, Void>
    @State var presentedSheet = false
    private var views: Dependency.Views

    init(
        familyListViewModel: ObservableViewModel<FamilyListState, Void>,
        views: Dependency.Views
    ) {
        self.familyListViewModel = familyListViewModel
        self.views = views
    }

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(familyListViewModel.state.members) { member in
                    UserCardView(user: member)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if familyListViewModel.state.shouldRenderAddMemberButton {
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
        FamilyListView(
            familyListViewModel: .init(
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
    var familyListView: FamilyListView {
        return FamilyListView(
            familyListViewModel: ObservableViewModel(viewModel: viewModels.familyListViewModel),
            views: self
        )
    }
}
