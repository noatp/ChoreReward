//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import SwiftUI

// MARK: Main Implementaion

enum FilterOptions: String {
    case all = "All chores"
    case yours = "Your chores"
}

struct ChoreTabView: View {
    @Namespace private var animation
    @ObservedObject var choreTabViewModel: ObservableViewModel<ChoreTabState, ChoreTabAction>
    @State private var presentedFilterDropdown = false
    @Binding private var presentedDrawer: Bool
    @State private var filterState: FilterOptions = .all

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
        UnwrapViewState(viewState: choreTabViewModel.viewState) { viewState in
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    choreStatusPicker
                    Spacer()
                    filterMenu
                }
                .background {
                    Color.bg
                }
                Color.accentGraySecondary.frame(maxHeight: 1)

                if viewState.displayingChoreList.isEmpty {
                    emptyChoreList
                } else {
                    if viewState.deletableChore {
                        List {
                            ForEach(viewState.displayingChoreList) {chore in
                                ZStack(alignment: .leading) {
                                    NavigationLink {
                                        views.choreDetailView(chore: chore)
                                    } label: {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    ChoreCard(chore: chore)
                                }

                            }
                            .onDelete(perform: { offsets in
                                choreTabViewModel.perform(action: .deleteChore(offsets))
                            })
                            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .refreshable {
                            choreTabViewModel.perform(action: .refreshChoreList)
                        }
                    } else {
                        List {
                            ForEach(viewState.displayingChoreList) {chore in

                                ZStack(alignment: .leading) {
                                    NavigationLink {
                                        views.choreDetailView(chore: chore)
                                    } label: {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    ChoreCard(chore: chore)
                                }

                            }
                            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .refreshable {
                            choreTabViewModel.perform(action: .refreshChoreList)
                        }
                    }
                }
            }
            .vNavBar(NavigationBar(
                title: "Chore",
                leftItem: menuButton,
                rightItem: EmptyView(),
                navBarLayout: .leftTitle
            ))
        }
    }
}

// MARK: Preview

struct ChoreTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabView(
            presentedDrawer: .constant(false),
            choreTabViewModel: ObservableViewModel(staticState: .preview),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)

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
        UnwrapViewState(viewState: choreTabViewModel.viewState) { viewState in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        CustomizableRegularButton {
                            Text("Unfinished")
                                .frame(maxWidth: .infinity)
                        } action: {
                            choreTabViewModel.perform(action: .updatePickerState(.unfinished))
                        }

                        if viewState.chorePickerState == .unfinished {
                            Color.accent
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "pickerBackground", in: animation)
                        } else {
                            Color.clear.frame(height: 3)
                        }
                    }

                    VStack(spacing: 0) {
                        CustomizableRegularButton {
                            Text("Finished")
                                .frame(maxWidth: .infinity)
                        } action: {
                            choreTabViewModel.perform(action: .updatePickerState(.finished))
                        }

                        if viewState.chorePickerState == .finished {
                            Color.accent
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "pickerBackground", in: animation)
                        } else {
                            Color.clear.frame(height: 3)
                        }
                    }
                }
            }
            .background {
                Color.bg
            }
            .animation(.spring(), value: viewState.chorePickerState)
        }
    }

    private var filterMenu: some View {
        Menu {
            RegularButton(buttonTitle: "All chores", action: {
                filterState = .all
                choreTabViewModel.perform(action: .updateFilterState(.all))
            })
            RegularButton(buttonTitle: "Your chores", action: {
                filterState = .yours
                choreTabViewModel.perform(action: .updateFilterState(.takenByCurrentUser))
            })
        } label: {
            Text(filterState.rawValue)
                .fixedSize()
        }
        .foregroundColor(.accent)
        .tappableFrame()
        .smallHorizontalPadding()
    }

    private var menuButton: some View {
        RegularButton(buttonImage: "line.3.horizontal", action: {
            withAnimation {
                presentedDrawer = true
            }
        })
    }

    private var emptyChoreList: some View {
        VStack {
            Spacer()
            Text("No chores")
            Spacer()
        }
    }

}
