//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import SwiftUI

enum FinishedPickerState{
    case finished, unfinished
}

struct ChoreTabView: View {
    @ObservedObject var choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>
    @State private var presentedSheet = false
    @State private var finishedPickerState: FinishedPickerState = .unfinished
    @State private var presentFilterMenu = false
    @Namespace private var animation
    private var views: Dependency.Views
    
    init(
        choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>,
        views: Dependency.Views
    ){
        self.choreTabViewModel = choreTabViewModel
        self.views = views
    }
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                HStack(spacing: 0){
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            finishedPickerState = .unfinished
                        }
                    } label: {
                        Text("Unfinished")
                            .foregroundColor(.fg)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background{
                        if (finishedPickerState == .unfinished){
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundColor(.bg3)
                                .matchedGeometryEffect(id: "pickerBackground", in: animation)
                        }
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            finishedPickerState = .finished
                        }
                    } label: {
                        Text("Finished")
                            .foregroundColor(.fg)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background{
                        if (finishedPickerState == .finished){
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundColor(.bg3)
                                .matchedGeometryEffect(id: "pickerBackground", in: animation)
                        }
                    }
                }
                .background{
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundColor(.bg2)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        presentFilterMenu.toggle()
                    }
                } label: {
                    HStack{
                        Image(systemName: "tray")
                        Text("Filter")
                    }
                }
                .foregroundColor(.white)

            }
            .padding([.leading, .bottom, .trailing])
            .background(Color.bg)
            
            ZStack(alignment: .top){
                ScrollView(showsIndicators: false){
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
                        .transition(.move(edge: .leading))
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
                        .transition(.move(edge: .trailing))
                    }
                    
                }
                .padding(.horizontal)
                if (presentFilterMenu){
                    VStack(alignment: .leading){
                        Divider()
                        HStack{
                            Image(systemName: "house")
                            Text("All chores")
                            Spacer()
                        }
                        Divider()
                        HStack{
                            Image(systemName: "person")
                            Text("Chores you took")
                            Spacer()
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                    .background(Color.bg)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
               
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
            .navigationBarHidden(true)
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

extension ChoreTabView{
    private var addChoreButton: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button {
                    presentedSheet = true

                } label: {
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.fg)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .padding()
                }
            }
        }
    }
}
