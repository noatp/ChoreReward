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
            ScrollView{
                Image("unfinishedDishes")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .clipped()

                VStack(alignment: .leading){
                    Text("\(chore.title)")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Chore put up by: \(chore.assignerId)")
                        .font(.footnote)
                    Text("on \(chore.created.formatted(date: .abbreviated, time: .omitted))")
                        .font(.footnote)
                        .padding(.bottom)
                    
                    Text("Detail")
                        .font(.headline)
                    Text(chore.description)
                        .padding(.bottom)
                                        
                    if (chore.assigneeId != ""){
                        Text("Chore taken by: \(chore.assigneeId)")
                        if (chore.completed != nil){
                            Text("Chore is completed on \(chore.completed!.formatted(date: .abbreviated, time: .omitted))")
                        }
                        else{
                            Text("Chore is not completed")
                        }
                    }
                }
                .padding(.horizontal)
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
            .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                }

            }
        }
    }
}

struct ChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        let previewChoreNotTaken = Chore(
//            id: "id",
//            title: "Wash the dishes",
//            assignerId: "preview assignerId",
//            assigneeId: "",
//            completed: nil,
//            created: Date(),
//            description: "The dishes has been here for a couple of days now, please wash them"
//        )
//
//        let previewChoreTaken = Chore(
//            id: "id",
//            title: "Wash the dishes",
//            assignerId: "preview assignerId",
//            assigneeId: "preview assigneeId",
//            completed: nil,
//            created: Date(),
//            description: "The dishes has been here for a couple of days now"
//        )

        let previewChoreFinished = Chore(
            id: "id",
            title: "Wash the dishes",
            assignerId: "preview assignerId",
            assigneeId: "preview assigneeId",
            completed: Date(),
            created: Date(),
            description: "The dishes has been here for a couple of days now, please wash them"
        )
//        ChoreDetailView(
//            choreDetailViewModel: ObservableViewModel(
//                staticState: choreDetailState(chore: previewChoreNotTaken)
//            ),
//            views: Dependency.preview.views()
//        )
//        ChoreDetailView(
//            choreDetailViewModel: ObservableViewModel(
//                staticState: choreDetailState(chore: previewChoreTaken)
//            ),
//            views: Dependency.preview.views()
//        )
        ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(
                staticState: choreDetailState(chore: previewChoreFinished)
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
