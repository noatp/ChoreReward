//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import SwiftUI

// MARK: Main Implementaion

struct ChoreTabView: View {
    @ObservedObject var choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>
    @State private var presentedSheet = false
    @State private var presentFilterMenu = false
    @Namespace private var animation
    private var views: Dependency.Views

    init(
        choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>,
        views: Dependency.Views
    ) {
        self.choreTabViewModel = choreTabViewModel
        self.views = views
    }

    var body: some View {
        VStack(spacing: 0) {
            filterAndPickerBar

            ZStack {
                if choreTabViewModel.state.displayingChoreList.isEmpty {
                    VStack {
                        Spacer()
                        Text("No chores")
                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(choreTabViewModel.state.displayingChoreList) {chore in
                                NavigationLink {
                                    views.choreDetailView(chore: chore)
                                } label: {
                                    ChoreCardView(chore: chore)
                                }

                                .transition(.move(edge: choreTabViewModel.state.chorePickerState == .unfinished ? .leading : .trailing))
                            }
                        }
                        .animation(.easeInOut, value: choreTabViewModel.state.chorePickerState)
                    }
                }

                if presentFilterMenu {
                    filterMenu
                }
            }

        }
    }
}

// MARK: Preview

struct ChoreTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabView(
            choreTabViewModel: ObservableViewModel(
                staticState: .init(
                    displayingChoreList: [
                        Chore.previewChoreFinished,
                        Chore.previewChoreFinished_1,
                        Chore.previewChoreUnfinished
                    ],
                    choreFilterState: .all,
                    chorePickerState: .unfinished
                )
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)

    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    func choreTabView() -> ChoreTabView {
        return ChoreTabView(
            choreTabViewModel: ObservableViewModel(
                viewModel: viewModels.choreTabViewModel
            ),
            views: self
        )
    }
}

// MARK: Subviews

extension ChoreTabView {
    private var choreStatusPicker: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                RegularButtonView(buttonTitle: "Unfinished") {
                    choreTabViewModel.perform(action: .updatePickerState(.unfinished))
                }
                if choreTabViewModel.state.chorePickerState == .unfinished {
                    Color.accent
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "pickerBackground", in: animation)
                } else {
                    Color.clear.frame(height: 2)
                }
            }

            VStack(spacing: 5) {
                RegularButtonView(buttonTitle: "Finished", action: {
                    choreTabViewModel.perform(action: .updatePickerState(.finished))
                })
                if choreTabViewModel.state.chorePickerState == .finished {
                    Color.accent
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "pickerBackground", in: animation)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
        }
        .animation(.spring(), value: choreTabViewModel.state.chorePickerState)
    }

    private var filterButton: some View {
        RegularButtonView(buttonTitle: "Filter", buttonImage: "tray") {
            withAnimation(.easeInOut(duration: 0.2)) {
                presentFilterMenu.toggle()
            }
        }
        .foregroundColor(.white)
    }

    private var filterMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Divider()
                RegularButtonView(buttonTitle: "All", buttonImage: "house") {
                    choreTabViewModel.perform(action: .updateFilterState(.all))
                    presentFilterMenu.toggle()
                }
                Divider()
                RegularButtonView(buttonTitle: "Yours", buttonImage: "person") {
                    choreTabViewModel.perform(action: .updateFilterState(.takenByCurrentUser))
                    presentFilterMenu.toggle()
                }

            }
            .padding([.leading, .bottom, .trailing])
            .background(Color.bg)
            .foregroundColor(.fg)
            Spacer()
        }

    }

    private var filterAndPickerBar: some View {
        HStack {
            choreStatusPicker
            Spacer()
            filterButton
        }
        .padding([.leading, .bottom, .trailing])
        .background(Color.bg)
    }
}
