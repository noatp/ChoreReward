//
//  ChoreDetailView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey{
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
    
    static var defaultValue: Double = 0.0
}

struct ChoreDetailView: View {
    @ObservedObject var choreDetailViewModel: ObservableViewModel<choreDetailState, choreDetailAction>
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var navBarOpacity: Double = 0
    @State private var scrollPos: Double = 0
    private var chore: Chore{choreDetailViewModel.state.chore}
    private var views: Dependency.Views
        
    init(
        choreDetailViewModel: ObservableViewModel<choreDetailState, choreDetailAction>,
        views: Dependency.Views
    ){
        self.choreDetailViewModel = choreDetailViewModel
        self.views = views
    }
    
    var body: some View {
        NavBarContainerView(navBarTitle: chore.title, navBarOpacity: navBarOpacity) {
            ScrollView{
                VStack{
                    Image("unfinishedDishes")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .clipped()
                }
                .background(GeometryReader { geoProxy in
                    let offset = geoProxy.frame(in: .global).minY / 100 * -1
                    Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                })
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    print(value)
                    navBarOpacity = value
                }
                
                ChoreDetailText
                
                if (chore.assigneeId == ""){
                    takeChoreButton
                }
                
                if (chore.assigneeId != ""){
                    if (chore.completed == nil){
                        completeChoreButton
                    }
                }
            }
            
            .ignoresSafeArea(edges: .top)
        }
    }
}

struct ChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let previewChoreFinished = Chore(
            id: "id",
            title: "Wash the dishes",
            assignerId: "preview assignerId",
            assigneeId: "preview assigneeId",
            completed: Date(),
            created: Date(),
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing elit pellentesque. Id venenatis a con"
        )
        
        NavigationView{
            ChoreDetailView(
                choreDetailViewModel: ObservableViewModel(
                    staticState: choreDetailState(chore: previewChoreFinished)
                ),
                views: Dependency.preview.views()
            )
        }
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

extension ChoreDetailView{
    private var ChoreDetailText: some View{
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
    }
    
    private var takeChoreButton: some View{
        ButtonView(
            action: {
                choreDetailViewModel.perform(action: .takeChore)
            },
            buttonTitle: "Take chore",
            buttonImage: "figure.wave",
            buttonColor: .accentColor
        )
    }
    
    private var completeChoreButton: some View{
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
