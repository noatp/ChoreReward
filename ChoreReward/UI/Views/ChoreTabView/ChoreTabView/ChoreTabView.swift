//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import SwiftUI

struct ChoreTabView: View {
    @ObservedObject var choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>
    @State var presentedSheet = false
    @State private var finishedPickerState: FinishedPickerState = .unfinished
    private var views: Dependency.Views
    
    init(
        choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>,
        views: Dependency.Views
    ){
        self.choreTabViewModel = choreTabViewModel
        self.views = views
    }
    
    var body: some View {
        ChoreTabNavBarContainer(pickerStateBinding: $finishedPickerState){
            VStack{
                ScrollView{
                    if (finishedPickerState == .unfinished){
                        ForEach(choreTabViewModel.state.unfinishedChoreList) {chore in
                            VStack{
                                NavigationLink {
                                    views.choreDetailView(chore: chore)
                                } label: {
                                    ChoreCardView(chore: chore)
                                }
                            }
                        }
                    }
                    else{
                        ForEach(choreTabViewModel.state.finishedChoreList) {chore in
                            VStack{
                                NavigationLink {
                                    views.choreDetailView(chore: chore)
                                } label: {
                                    ChoreCardView(chore: chore)
                                }
                            }
                        }
                    }
                    
                }
                
                if (choreTabViewModel.state.shouldRenderAddChoreButton){
                    ButtonView(
                        action: {
                            presentedSheet = true
                        },
                        buttonTitle: "Add Chore",
                        buttonImage: "plus",
                        buttonColor: .accentColor
                    )
                }
            }
            .padding()
            .sheet(isPresented: $presentedSheet, onDismiss: {}) {
                views.addChoreView()
            }
        }
    }
}

struct ChoreTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChoreTabView(
                choreTabViewModel: ObservableViewModel(
                    staticState: .init(
                        shouldRenderAddChoreButton: true,
                        unfinishedChoreList: [Chore(
                            id: "previewId1",
                            title: "unfinished chore",
                            assignerId: "",
                            assigneeId: "",
                            completed: nil,
                            created: Date(),
                            description: "unfinished chore"
                        )],
                        finishedChoreList: [Chore(
                            id: "previewId2",
                            title: "finished chore",
                            assignerId: "",
                            assigneeId: "",
                            completed: Date(),
                            created: Date(),
                            description: "finished chore")
                        ]
                    )
                ),
                views: Dependency.preview.views()
            )
        }
        .preferredColorScheme(.dark)
    }
}

extension Dependency.Views{
    func choreTabView() -> ChoreTabView{
        return ChoreTabView(
            choreTabViewModel: ObservableViewModel(
                viewModel: viewModels.choreTabViewModel
            ),
            views: self
        )
    }
}
