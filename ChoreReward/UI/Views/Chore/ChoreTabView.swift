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
        UnwrapViewState(viewState: choreTabViewModel.viewState) { viewState in
            VStack(spacing: 0) {
                HStack {
                    choreStatusPicker
                    Spacer()
                    filterMenu
                }
                .padding([.horizontal], StylingSize.largePadding)
                .padding([.bottom], StylingSize.mediumPadding)
                .background(Color.toolbarBg)

                Color.border.frame(maxHeight: 1)

                if viewState.displayingChoreList.isEmpty {
                    emptyChoreList
                } else {
                    if viewState.deletableChore {
                        List {
                            ForEach(viewState.displayingChoreList) {chore in
                                if let choreId = chore.id {
                                    ZStack(alignment: .leading) {
                                        NavigationLink {
                                            views.choreDetailView(choreId: choreId)
                                        } label: {
                                            EmptyView()
                                        }
                                        .opacity(0)
                                        ChoreCard(chore: chore)
                                    }
                                    .padding([.bottom], StylingSize.largePadding)
                                    .listRowBackground(Color.bg)
                                }
                            }
                            .onDelete(perform: { offsets in
                                choreTabViewModel.perform(action: .deleteChore(offsets))
                            })
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .refreshable {
                            choreTabViewModel.perform(action: .refreshChoreList)
                        }
                    } else {
                        List {
                            ForEach(viewState.displayingChoreList) {chore in

                                if let choreId = chore.id {
                                    ZStack(alignment: .leading) {
                                        NavigationLink {
                                            views.choreDetailView(choreId: choreId)
                                        } label: {
                                            EmptyView()
                                        }
                                        .opacity(0)
                                        ChoreCard(chore: chore)
                                    }
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

        ChoreTabView(
            presentedDrawer: .constant(false),
            choreTabViewModel: ObservableViewModel(staticState: .preview),
            views: Dependency.preview.views()
        )
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
            HStack(spacing: 0) {
                CustomizableRegularButton {
                    Text("Unfinished")
                } action: {
                    choreTabViewModel.perform(action: .updatePickerState(.unfinished))
                }
                .smallHorizontalPadding()
                .smallVerticalPadding()
                .foregroundColor(viewState.chorePickerState == .unfinished ? Color.pickerFgActive : Color.altFg)
                .background {
                    if viewState.chorePickerState == .unfinished {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundColor(.pickerAccent)
                            .matchedGeometryEffect(id: "pickerBackground", in: animation)
                    }
                }

                CustomizableRegularButton {
                    Text("Finished")
                } action: {
                    choreTabViewModel.perform(action: .updatePickerState(.finished))
                }
                .smallHorizontalPadding()
                .smallVerticalPadding()
                .foregroundColor(viewState.chorePickerState == .finished ? Color.pickerFgActive : Color.altFg)
                .background {
                    if viewState.chorePickerState == .finished {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundColor(.pickerAccent)
                            .matchedGeometryEffect(id: "pickerBackground", in: animation)
                    }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundColor(.pickerBg)
            }
            .animation(.easeInOut(duration: 0.35), value: viewState.chorePickerState)
        }
    }

    private var filterMenu: some View {
        UnwrapViewState(viewState: choreTabViewModel.viewState) { viewState in
            Menu(content: {
                ForEach(ChoreFilterState.allCases, id: \.label) { filterStateCase in
                    RegularButton(
                        buttonTitle: filterStateCase.label,
                        buttonImage: filterStateCase.icon
                    ) {
                        choreTabViewModel.perform(action: .updateFilterState(filterStateCase))
                    }
                }
            }, label: {
                Label(viewState.choreFilterState.label, systemImage: viewState.choreFilterState.icon)
            })
            .font(StylingFont.headline)
            .foregroundColor(.accent)
            .smallHorizontalPadding()
            .capsuleFrame(background: .contrastBtnBg)
            .animation(nil, value: viewState.choreFilterState)
        }
    }

    private var menuButton: some View {
        CircularButton(action: {
            withAnimation {
                presentedDrawer = true
            }
        }, icon: "line.3.horizontal")
    }

    private var emptyChoreList: some View {
        UnwrapViewState(viewState: choreTabViewModel.viewState) { viewState in

            VStack {
                Spacer()
                Text(viewState.shouldShowAddChorePrompt
                     ? "Tap the \"+\" button below to add new chore!"
                     : "There is no new chore."
                )
                    .font(StylingFont.headline)
                Spacer()
            }
        }
    }

}
