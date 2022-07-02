//
//  FamilyListView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI

// MARK: Main Implementaion

struct FamilyTabView: View {
    @ObservedObject var familyTabViewModel: ObservableViewModel<FamilyTabState, Void>
    @State var presentedAddMemberSheet = false
    @Binding private var presentedDrawer: Bool

    private var views: Dependency.Views

    init(
        presentedDrawer: Binding<Bool>,
        familyTabViewModel: ObservableViewModel<FamilyTabState, Void>,
        views: Dependency.Views
    ) {
        self._presentedDrawer = presentedDrawer
        self.familyTabViewModel = familyTabViewModel
        self.views = views
    }

    var body: some View {
        List {
            ForEach(familyTabViewModel.state.members) { member in
                UserCard(user: member)
            }
            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .padding()
        .vNavBar(NavigationBar(
            title: "Family",
            leftItem: menuButton,
            rightItem: addFamilyMemberButton,
            navBarLayout: .leftTitle
        ))
        .fullScreenCover(isPresented: $presentedAddMemberSheet) {
            views.addFamilyMemberView()
        }
    }
}

// MARK: Preview

struct FamilyListView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyTabView(
            presentedDrawer: .constant(false),
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

// MARK: Add to Dependency

extension Dependency.Views {
    func familyTabView(presentedDrawer: Binding<Bool>) -> FamilyTabView {
        return FamilyTabView(
            presentedDrawer: presentedDrawer,
            familyTabViewModel: ObservableViewModel(viewModel: viewModels.familyTabViewModel),
            views: self
        )
    }
}

// MARK: Subviews

extension FamilyTabView {
    private var menuButton: some View {
        RegularButton(buttonImage: "line.3.horizontal", action: {
            withAnimation {
                presentedDrawer = true
            }
        })
    }

    private var addFamilyMemberButton: some View {
        RegularButton(buttonImage: "plus") {
            presentedAddMemberSheet = true
        }
    }
}
