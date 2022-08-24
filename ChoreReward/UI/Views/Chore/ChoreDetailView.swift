//
//  ChoreDetailView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import SwiftUI

// MARK: Main Implementaion

struct ChoreDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var choreDetailViewModel: ObservableViewModel<ChoreDetailState, ChoreDetailAction>
    @State private var navBarOpacity: Double = 0
    @State private var scrollPos: Double = 0

    private var views: Dependency.Views

    init(
        choreDetailViewModel: ObservableViewModel<ChoreDetailState, ChoreDetailAction>,
        views: Dependency.Views
    ) {
        self.choreDetailViewModel = choreDetailViewModel
        self.views = views
    }

    var body: some View {
        UnwrapViewState(viewState: choreDetailViewModel.viewState) { viewState in
            ScrollView {
                RemoteImage(imageUrl: viewState.chore.choreImageUrl)
                    .frame(maxWidth: .infinity, maxHeight: 400, alignment: .center)
                    .clipped()
                    .scrollViewOffset($navBarOpacity)
                choreDetailText
                if viewState.chore.assignee == nil {
                    takeChoreButton
                } else {
                    if viewState.chore.finished == nil {
                        completeChoreButton
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .zNavBar(NavigationBar(
                title: viewState.chore.title,
                leftItem: dismissButton,
                rightItem: EmptyView(),
                opacity: navBarOpacity
            ))
        }
    }
}

// MARK: Preview

struct ChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(staticState: .previewFinished),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
        .previewDisplayName("Finished chore")

        ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(staticState: .previewUnfinished),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
        .previewDisplayName("Unfinished chore")

        ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(staticState: .previewUnassigned),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
        .previewDisplayName("Unassigned chore")
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    func choreDetailView(choreId: String) -> ChoreDetailView {
        return ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(
                viewModel: viewModels.choreDetailViewModel(choreId: choreId)
            ),
            views: self
        )
    }
}

// MARK: Subviews

extension ChoreDetailView {
    private var choreDetailText: some View {
        UnwrapViewState(viewState: choreDetailViewModel.viewState) { _ in
            VStack(alignment: .leading, spacing: 0) {
                titleSection
                statusSection
                detailSection
            }
            .padding(.horizontal, StylingSize.largePadding)
        }
    }

    private var takeChoreButton: some View {
        RegularButton(buttonTitle: "Take chore", buttonImage: "figure.wave") {
            choreDetailViewModel.perform(action: .takeChore)
        }
    }

    private var completeChoreButton: some View {
        RegularButton(buttonTitle: "Complete chore", buttonImage: "checkmark.seal.fill") {
            choreDetailViewModel.perform(action: .completeChore)
        }
    }

    private var dismissButton: some View {
        CircularButton(action: {
            dismiss()
        }, icon: "xmark")
    }

    private var titleSection: some View {
        UnwrapViewState(viewState: choreDetailViewModel.viewState) { viewState in
            VStack(alignment: .leading, spacing: .zero) {
                Text("\(viewState.chore.title)")
                    .font(StylingFont.largeTitle)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                Text("Reward: $\(viewState.chore.rewardValue)")
                    .font(StylingFont.smallTitle)
            }
        }
    }

    private var statusSection: some View {
        UnwrapViewState(viewState: choreDetailViewModel.viewState) { viewState in
            VStack(alignment: .leading, spacing: .zero) {
                Divider()
                    .padding(StylingSize.largePadding)
                Text("Posted by")
                    .font(StylingFont.caption)
                HStack(spacing: 0) {
                    Group {
                        if let assignerImageUrl = viewState.chore.assigner.userImageUrl {
                            RemoteImage(imageUrl: assignerImageUrl)
                        } else {
                            RegularImage(systemImage: "person.fill")
                        }
                    }
                    .frame(width: 30, height: 30, alignment: .center)
                    .clipShape(Circle())
                    Text(" \(viewState.chore.assigner.name ?? "")")
                        .font(StylingFont.headline)
                    + Text(" • \(viewState.chore.created.stringDateDistanceFromNow) ago")
                        .font(StylingFont.subhead)
                    Spacer(minLength: 0)
                }
                .padding(.bottom, StylingSize.largePadding)

                Text("Status")
                    .font(StylingFont.caption)
                Group {
                    if viewState.chore.assignee != nil {
                        if viewState.chore.finished != nil {
                            Text("Finished")
                                .font(StylingFont.headline)
                            + Text(" • \(viewState.chore.finished!.stringDateDistanceFromNow) ago")
                                .font(StylingFont.subhead)
                        } else {
                            Text("In progress")
                        }
                    } else {
                        Text("Available")
                    }
                }
                .padding(.bottom, StylingSize.largePadding)

                if let assignee = viewState.chore.assignee {
                    Text("Picked up by")
                        .font(StylingFont.caption)
                    HStack(spacing: 0) {
                        Group {
                            if let assigneeImageUrl = assignee.userImageUrl {
                                RemoteImage(imageUrl: assigneeImageUrl)
                            } else {
                                RegularImage(systemImage: "person.fill")
                            }
                        }
                        .frame(width: 30, height: 30, alignment: .center)
                        .clipShape(Circle())
                        Text(" \(assignee.name ?? "")")
                            .font(StylingFont.headline)
                    }
                }
            }
        }
    }

    private var detailSection: some View {
        UnwrapViewState(viewState: choreDetailViewModel.viewState) { viewState in
            VStack(alignment: .leading, spacing: .zero) {
                Divider()
                    .padding(StylingSize.largePadding)
                Text("Details")
                    .font(StylingFont.smallTitle)
                Text(viewState.chore.description)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
