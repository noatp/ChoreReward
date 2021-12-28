//
//  NoFamilyView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/26/21.
//

import SwiftUI

struct NoFamilyView: View {
    @ObservedObject var noFamilyViewModel: NoFamilyViewModel
    private var views: Dependency.Views
    
    init(
        noFamilyViewModel: NoFamilyViewModel,
        views: Dependency.Views
    ){
        self.noFamilyViewModel = noFamilyViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            Text("Please ask your family's admin to invite you to the family")
                .multilineTextAlignment(.center)
            Text("This is your user ID: ")
            Text(noFamilyViewModel.currentUserId)
            if (noFamilyViewModel.shouldRenderButtons){
                Button("Create a new family") {
                    noFamilyViewModel.createFamily()
                }
            }
        }
        .padding()
    }
}

struct NoFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().noFamilyView

    }
}

extension Dependency.Views{
    var noFamilyView: NoFamilyView{
        return NoFamilyView(
            noFamilyViewModel: viewModels.noFamilyViewModel,
            views: self
        )
    }
}
