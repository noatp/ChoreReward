//
//  NoFamilyView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/26/21.
//

import SwiftUI

struct NoFamilyView: View {
    @ObservedObject var noFamilyViewModel: ObservableViewModel<NoFamilyState, NoFamilyAction>
    private var views: Dependency.Views
    
    init(
        noFamilyViewModel: ObservableViewModel<NoFamilyState, NoFamilyAction>,
        views: Dependency.Views
    ){
        self.noFamilyViewModel = noFamilyViewModel
        self.views = views
    }
    
    var body: some View {
        VStack(spacing: 16){
            Text("Please ask your family's admin to invite you to the family")
                .multilineTextAlignment(.center)
            Text("This is your user ID: ")
            Text(noFamilyViewModel.state.currentUserId)
            if (noFamilyViewModel.state.shouldRenderCreateFamilyButton){
                Button("Create a new family") {
                    noFamilyViewModel.perform(action: .createFamily)
                }
            }
        }
        .padding()
    }
}

struct NoFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NoFamilyView(
                noFamilyViewModel: .init(
                    staticState: .init(
                        shouldRenderCreateFamilyButton: true,
                        currentUserId: "preview userId"
                    )
                ),
                views: Dependency.preview.views())
        }
    }
}

extension Dependency.Views{
    var noFamilyView: NoFamilyView{
        return NoFamilyView(
            noFamilyViewModel: ObservableViewModel(viewModel: viewModels.noFamilyViewModel),
            views: self
        )
        
    }
}
