//
//  JoinFamilyView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/14/21.
//

import SwiftUI

struct JoinFamilyView: View {
    @ObservedObject var joinFamilyViewModel: JoinFamilyViewModel
    private var views: Dependency.Views
    
    init(
        joinFamilyViewModel: JoinFamilyViewModel,
        views: Dependency.Views
    ){
        self.joinFamilyViewModel = joinFamilyViewModel
        self.views = views
    }
    
    var body: some View {
        TextFieldView(textFieldViewModel: joinFamilyViewModel.familyIdInputRender)
        Button("Join Family", action: {
            joinFamilyViewModel.joinFamilyWithId()
        })
    }
}

struct JoinFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().joinFamilyView
    }
}

extension Dependency.Views{
    var joinFamilyView: JoinFamilyView{
        return JoinFamilyView(
            joinFamilyViewModel: viewModels.joinFamilyViewModel,
            views: self
        )
    }
}

