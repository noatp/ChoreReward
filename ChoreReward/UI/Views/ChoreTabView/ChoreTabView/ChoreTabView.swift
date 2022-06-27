//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import SwiftUI

// MARK: Main Implementaion

struct ChoreTabView: View {
    @Namespace private var animation
    @ObservedObject var choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>
    @State private var presentedFilterDropdown = false
    @Binding private var presentedDrawer: Bool

    private var views: Dependency.Views

    init(
        presentedDrawer: Binding<Bool>,
        choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>,
        views: Dependency.Views
    ) {
        self._presentedDrawer = presentedDrawer
        self.choreTabViewModel = choreTabViewModel
        self.views = views
    }

    var body: some View {
        VStack(spacing: 0) {
            choreStatusPicker

            ZStack {
                if choreTabViewModel.state.displayingChoreList.isEmpty {
                    emptyChoreList
                } else {
                    choreList
                }

                if presentedFilterDropdown {
                    filterMenu
                }
            }
        }
        .vNavBar(NavigationBar(
            title: "Chore",
            leftItem: menuButton,
            rightItem: filterButton,
            navBarLayout: .leftTitle
        ))
    }
}

// MARK: Preview

struct ChoreTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabView(
            presentedDrawer: .constant(false),
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
    func choreTabView(presentedDrawer: Binding<Bool>) -> ChoreTabView {
        return ChoreTabView(
            presentedDrawer: presentedDrawer,
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
                presentedFilterDropdown.toggle()
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
                    presentedFilterDropdown.toggle()
                }
                Divider()
                RegularButtonView(buttonTitle: "Yours", buttonImage: "person") {
                    choreTabViewModel.perform(action: .updateFilterState(.takenByCurrentUser))
                    presentedFilterDropdown.toggle()
                }

            }
            .padding([.leading, .bottom, .trailing])
            .background(Color.bg)
            .foregroundColor(.fg)
            Spacer()
        }

    }

    private var menuButton: some View {
        RegularButtonView(buttonImage: "line.3.horizontal", action: {
            withAnimation {
                presentedDrawer = true
            }
        })
    }

    private var choreList: some View {
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

    private var emptyChoreList: some View {
        VStack {
            Spacer()
            Text("No chores")
            Spacer()
        }
    }

}
