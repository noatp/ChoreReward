//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import SwiftUI

struct ChoreTabView: View {
    @ObservedObject var choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>
    @State private var presentedSheet = false
    @State private var presentFilterMenu = false
    @State private var onUnfinishedTab = true
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
                choreStatusPicker
                Spacer()
                filterButton
            }
            .padding([.leading, .bottom, .trailing])
            .background(Color.bg)
            
            ZStack(alignment: .top){
                ScrollView(showsIndicators: false){
                    ForEach(choreTabViewModel.state.displayingChoreList) {chore in
                        VStack{
                            NavigationLink {
                                views.choreDetailView(chore: chore)
                            } label: {
                                ChoreCardView(chore: chore)
                            }
                        }.transition(.move(edge: onUnfinishedTab ? .leading : .trailing))
                    }
                    
                }
                .padding(.horizontal)
                .animation(.easeInOut(duration: 0.2), value: choreTabViewModel.state.chorePickerState)
                if (presentFilterMenu){
                    filterMenu
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
                    staticState: .empty
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
    private var choreStatusPicker: some View{
        HStack(spacing: 0){
            Button {
                choreTabViewModel.perform(action: .updatePickerState(.unfinished))
                onUnfinishedTab = true
            } label: {
                Text("Unfinished")
                    .foregroundColor(.fg)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background{
                if (choreTabViewModel.state.chorePickerState == .unfinished){
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundColor(.bg3)
                        .matchedGeometryEffect(id: "pickerBackground", in: animation)
                }
            }
            
            Button {
                choreTabViewModel.perform(action: .updatePickerState(.finished))
                onUnfinishedTab = false
            } label: {
                Text("Finished")
                    .foregroundColor(.fg)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background{
                if (choreTabViewModel.state.chorePickerState == .finished){
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
        .animation(.easeInOut(duration: 0.2), value: choreTabViewModel.state.chorePickerState)
    }
    
    private var filterButton: some View{
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
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
    
    private var filterMenu: some View{
        VStack(alignment: .leading){
            Divider()
            
            Button {
                choreTabViewModel.perform(action: .updateFilterState(.all))
                presentFilterMenu.toggle()
            } label: {
                HStack{
                    Image(systemName: "house")
                    Text("All")
                    Spacer()
                }
            }

            
            Divider()
            Button {
                choreTabViewModel.perform(action: .updateFilterState(.takenByCurrentUser))
                presentFilterMenu.toggle()
            } label: {
                HStack{
                    Image(systemName: "person")
                    Text("Yours")
                    Spacer()
                }
            }

            
        }
        .padding([.leading, .bottom, .trailing])
        .background(Color.bg)
        .foregroundColor(.fg)
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
    }
}
