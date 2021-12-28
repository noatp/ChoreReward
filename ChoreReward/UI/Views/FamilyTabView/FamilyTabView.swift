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
            if familyTabViewModel.currentFamily != nil {
                HStack{
                    views.familyListView
                }
            }
            else{
                views.noFamilyView
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
