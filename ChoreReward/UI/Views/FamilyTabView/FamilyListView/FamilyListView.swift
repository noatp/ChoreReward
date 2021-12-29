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
            Text("Family members:")
            ScrollView {
                ForEach(familyListViewModel.members){ member in
                    UserCardView(user: member)
                }
                if (familyListViewModel.shouldRenderButtons){
                    NavigationLink("Add new member") {
                        views.addFamilyMemberView
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct FamilyListView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().familyListView

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
