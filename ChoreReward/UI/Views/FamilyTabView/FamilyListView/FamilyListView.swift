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
    ){
        self.familyListViewModel = familyListViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            ScrollView {
                ForEach(familyListViewModel.state.members){ member in
                    UserCardView(user: member)
                }
            }
            if (familyListViewModel.state.shouldRenderAddMemberButton){
                ButtonView(
                    action: {
                        presentedSheet = true
                    },
                    buttonTitle: "Add new member",
                    buttonImage: "person.badge.plus",
                    buttonColor: .accentColor
                )
            }
        }
        .padding()
        .navigationTitle("Family Members")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $presentedSheet) {
            views.addFamilyMemberView()
        }
    }
}

struct FamilyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FamilyListView(
                familyListViewModel: .init(
                    staticState: .init(
                        members: User.previewMembers,
                        shouldRenderAddMemberButton: true
                    )
                ),
                views: Dependency.preview.views())
        }
    }
}

extension Dependency.Views{
    var familyListView: FamilyListView{
        return FamilyListView(
            familyListViewModel: ObservableViewModel(viewModel: viewModels.familyListViewModel),
            views: self
        )
    }
}
