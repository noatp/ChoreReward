//
//  FamilyTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct FamilyTabView: View {
    @ObservedObject var familyTabViewModel: FamilyTabViewModel
    private var views: Dependency.Views
    
    init(
        familyTabViewModel: FamilyTabViewModel,
        views: Dependency.Views
    ){
        self.familyTabViewModel = familyTabViewModel
        self.views = views
    }
    var body: some View {
        HStack{
            if let currentFamily = familyTabViewModel.currentFamily{
                HStack{
                    views.familyListView
                }
            }
            else{
                VStack{
                    Button("Create a new family") {
                        familyTabViewModel.createFamily()
                    }
                    .padding()
                    NavigationLink("Join an existing family") {
                        views.joinFamilyView
                    }
                }
            }
        }
    }
}

struct FamilyTabView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().familyTabView
    }
}

extension Dependency.Views{
    var familyTabView: FamilyTabView{
        return FamilyTabView(
            familyTabViewModel: viewModels.familyTabViewModel,
            views: self
        )
    }
}
