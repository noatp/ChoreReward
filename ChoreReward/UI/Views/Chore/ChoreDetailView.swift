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
                RemoteImage(imageUrl: viewState.chore.choreImageUrl, isThumbnail: false)
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
            choreDetailViewModel: ObservableViewModel(
                staticState: ChoreDetailState(chore: .previewChoreFinished)
            ),
            views: Dependency.preview.views()
        )
//        .previewLayout(.sizeThatFits)
        .font(StylingFont.regular)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    func choreDetailView(chore: Chore) -> ChoreDetailView {
        return ChoreDetailView(
            choreDetailViewModel: ObservableViewModel(
                viewModel: viewModels.choreDetailViewModel(chore: chore)
            ),
            views: self
        )
    }
}

// MARK: Subviews

extension ChoreDetailView {
    private var choreDetailText: some View {
        UnwrapViewState(viewState: choreDetailViewModel.viewState) { viewState in
            VStack(alignment: .leading, spacing: 0) {
                Text("\(viewState.chore.title)")
                    .font(StylingFont.title)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                Text("Reward: $\(viewState.chore.rewardValue)")
                    .font(StylingFont.large)
                    .padding(.bottom)
                HStack(spacing: 0) {
                    Text("Requested by: ")
                    Group {
                        if let assignerImageUrl = viewState.chore.assigner.userImageUrl {
                            RemoteImage(imageUrl: assignerImageUrl, isThumbnail: true)
                        } else {
                            RegularImage(systemImage: "person.fill")
                        }
                    }
                    .frame(width: 20, height: 20, alignment: .center)
                    .clipShape(Circle())
                    Text(" \(viewState.chore.assigner.name ?? "")")
                    Spacer(minLength: 0)
                }
                .font(StylingFont.medium)

                Text("on \(viewState.chore.created.dateTimestamp.formatted(date: .abbreviated, time: .omitted))")
                    .font(StylingFont.medium)
                    .padding(.bottom)

                Text("Description")
                    .font(StylingFont.large)
                Text(viewState.chore.description)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)

                if let assignee = viewState.chore.assignee {
                    HStack {
                        Group {
                            if let assigneeImageUrl = assignee.userImageUrl {
                                RemoteImage(imageUrl: assigneeImageUrl, isThumbnail: true)
                            } else {
                                RegularImage(systemImage: "person.fill")
                            }
                        }
                        .frame(width: 20, height: 20, alignment: .center)
                        .clipShape(Circle())
                        Text(" \(assignee.name ?? "") is working on this chore")
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .font(StylingFont.medium)
                    .padding(.bottom)

                    if let finished = viewState.chore.finished {
                        Text("Chore is finished on "
                             + "\(finished.dateTimestamp.formatted(date: .abbreviated, time: .omitted))")
                            .font(StylingFont.medium)
                    } else {
                        Text("Chore is not finished")
                            .font(StylingFont.medium)
                    }
                }
            }
            .padding(.horizontal)
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
}
