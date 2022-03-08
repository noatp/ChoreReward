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
        
    init(
        choreDetailViewModel: ObservableViewModel<choreDetailState, choreDetailAction>,
        views: Dependency.Views
    ){
        self.choreDetailViewModel = choreDetailViewModel
        self.views = views
    }
    
    var body: some View {
        if let chore = choreDetailViewModel.state.chore {
            VStack{
                Text("\(chore.title)")
                Spacer()
                Text("Chore put up by: ")
                Text("\(chore.assignerId)")
                Spacer()
                if (chore.assigneeId != ""){
                    Text("Chore taken by: ")
                    Text("\(chore.assigneeId)")
                    Spacer()
                    if (chore.completed != nil){
                        Text("Chore is completed")
                    }
                    else{
                        Text("Chore is not completed")
                    }
                }
                
                
                if (chore.assigneeId == ""){
                    ButtonView(
                        action: {
                            choreDetailViewModel.perform(action: .takeChore)
                        },
                        buttonTitle: "Take chore",
                        buttonImage: "figure.wave",
                        buttonColor: .accentColor
                    )
                }
                
                if (chore.assigneeId != ""){
                    if (chore.completed == nil){
                        ButtonView(
                            action: {
                                choreDetailViewModel.perform(action: .completeChore)
                            },
                            buttonTitle: "Complete chore",
                            buttonImage: "checkmark.seal.fill",
                            buttonColor: .green
                        )
                    }
                }
                
            }
            .padding()        }
        else{
            Text("No chore")
        }
    }
}

struct ChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(
                staticState: choreDetailState(chore: Chore.preview)
            ),
            views: Dependency.preview.views()
        )
    }
}

extension Dependency.Views{
    func choreDetailView(chore: Chore) -> ChoreDetailView{
        return ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(
                viewModel: viewModels.choreDetailViewModel(chore: chore)
            ),
            views: self
        )
    }
}
