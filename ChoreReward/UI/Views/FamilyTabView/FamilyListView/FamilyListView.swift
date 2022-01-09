//
//  FamilyListView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI

struct FamilyListView: View {
    @ObservedObject var familyListViewModel: FamilyListViewModel
    private var views: Dependency.Views
    
    init(
        familyListViewModel: FamilyListViewModel,
        views: Dependency.Views
    ){
        self.familyListViewModel = familyListViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            ScrollView {
                ForEach(familyListViewModel.members){ member in
                    UserCardView(user: member)
                }
            }
            if (familyListViewModel.shouldRenderButtons){
                NavigationLink (destination: views.addFamilyMemberView) {
                    Label("Add new member", systemImage: "person.badge.plus")
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("Family Members")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FamilyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Dependency.preview.views().familyListView
        }
    }
}

extension Dependency.Views{
    var familyListView: FamilyListView{
        return FamilyListView(
            familyListViewModel: viewModels.familyListViewModel,
            views: self
        )
    }
}
