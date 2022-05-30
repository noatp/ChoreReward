//
//  ChoreDetailView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import SwiftUI
import Kingfisher

struct ChoreDetailView: View {
    @ObservedObject var choreDetailViewModel: ObservableViewModel<choreDetailState, choreDetailAction>
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
        ChoreDetailNavBarView(navTitle: chore.title, opacity: navBarOpacity) {
            ScrollView{
//                RemoteImageView(
//                    imageUrl: chore.choreImageUrl,
//                    size: .init(width: 400, height: 400),
//                    cachingSize: .init(width: 400, height: 400)
//                )
//                .clipped()
                RemoteImageView(imageUrl: chore.choreImageUrl, isThumbnail: false)
                    .frame(maxWidth: .infinity, maxHeight: 400, alignment: .center)
                    .clipped()
                    .scrollViewOffset($navBarOpacity)
            
                choreDetailText
                
                if (!choreDetailViewModel.state.choreTaken){
                    takeChoreButton
                }
                else{
                    if (!choreDetailViewModel.state.choreCompleted){
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
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing elit pellentesque. Id venenatis a con",
            choreImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvaNbNa9E_46fY75AFA9N8dhocKjEdDegvrN5QbBHH-WX-oij4xtjeYijvpC_kHB9-FiU&usqp=CAU"
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
    private var choreDetailText: some View{
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
                                
            if (choreDetailViewModel.state.choreTaken){
                Text("Chore taken by: \(chore.assigneeId)")
                if (choreDetailViewModel.state.choreCompleted){
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
        ButtonView(buttonTitle: "Take chore", buttonImage: "figure.wave") {
            choreDetailViewModel.perform(action: .takeChore)
        }
    }
    
    private var completeChoreButton: some View{
        ButtonView(buttonTitle: "Complete chore", buttonImage: "checkmark.seal.fill") {
            choreDetailViewModel.perform(action: .completeChore)
        }
    }
}
