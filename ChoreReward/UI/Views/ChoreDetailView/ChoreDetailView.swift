//
//  ChoreDetailView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import SwiftUI

struct ChoreDetailView: View {
    @ObservedObject var choreDetailViewModel: ObservableViewModel<choreDetailState, choreDetailAction>
    private var views: Dependency.Views
    
    private let chore: Chore
    
    init(
        chore: Chore,
        choreDetailViewModel: ObservableViewModel<choreDetailState, choreDetailAction>,
        views: Dependency.Views
    ){
        self.chore = chore
        self.choreDetailViewModel = choreDetailViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            Text("\(chore.title)")
            Spacer()

            Text("Chore put up by: ")
            Text("\(chore.assigneeId)")
            Text("Chore taken by: ")
            Text("\(chore.assignerId)")
            Spacer()
            
            ButtonView(
                action: {
                    
                },
                buttonTitle: "Take chore",
                buttonImage: "figure.wave",
                buttonColor: .accentColor
            )
            
            ButtonView(
                action: {
                    
                },
                buttonTitle: "Complete chore",
                buttonImage: "checkmark.seal.fill",
                buttonColor: .green
            )
        }
        .padding()
    }
}

struct ChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreDetailView(
            chore: Chore.preview,
            choreDetailViewModel: ObservableViewModel(
                staticState: choreDetailState()
            ),
            views: Dependency.preview.views()
        )
    }
}

extension Dependency.Views{
    func choreDetailView(chore: Chore) -> ChoreDetailView{
        return ChoreDetailView(
            chore: chore,
            choreDetailViewModel: ObservableViewModel(
                viewModel: viewModels.choreDetailViewModel
            ),
            views: self
        )
    }
}
