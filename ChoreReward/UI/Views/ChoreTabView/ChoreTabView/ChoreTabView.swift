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
    private var views: Dependency.Views
    
    init(
        choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>,
        views: Dependency.Views
    ){
        self.choreTabViewModel = choreTabViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(choreTabViewModel.state.choreList) {chore in
                    NavigationLink {
                        views.choreDetailView
                    } label: {
                        ChoreCardView(chore: chore)
                    }
                    .foregroundColor(.black)
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
        .navigationTitle("Chores")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $presentedSheet, onDismiss: {}) {
            views.addChoreView()
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
                        choreList: []
                    )
                ),
                views: Dependency.preview.views()
            )
        }
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
