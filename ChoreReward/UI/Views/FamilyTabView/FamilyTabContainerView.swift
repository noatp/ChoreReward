//
//  FamilyTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct FamilyTabContainerView: View {
    @ObservedObject var familyTabViewModel: FamilyTabContainerViewModel
    private var views: Dependency.Views
    
    init(
        familyTabViewModel: FamilyTabContainerViewModel,
        views: Dependency.Views
    ){
        self.familyTabViewModel = familyTabViewModel
        self.views = views
    }
    var body: some View {
        if (familyTabViewModel.hasFamily){
            FamilyTabView()
        }
        else{
            Text("no family")
        }
    }
}

struct FamilyTabContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().familyTabContainerView
    }
}

extension Dependency.Views{
    var familyTabContainerView: FamilyTabContainerView{
        return FamilyTabContainerView(
            familyTabViewModel: viewModels.familyTabViewModel,
            views: self
        )
    }
}
