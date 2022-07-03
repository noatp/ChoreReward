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

    private var chore: Chore {choreDetailViewModel.state.chore}
    private var views: Dependency.Views

    init(
        choreDetailViewModel: ObservableViewModel<ChoreDetailState, ChoreDetailAction>,
        views: Dependency.Views
    ) {
        self.choreDetailViewModel = choreDetailViewModel
        self.views = views
    }

    var body: some View {
        ScrollView {
            RemoteImage(imageUrl: chore.choreImageUrl, isThumbnail: false)
                .frame(maxWidth: .infinity, maxHeight: 400, alignment: .center)
                .clipped()
                .scrollViewOffset($navBarOpacity)

            choreDetailText

            if !choreDetailViewModel.state.choreTaken {
                takeChoreButton
            } else {
                if !choreDetailViewModel.state.choreFinished {
                    completeChoreButton
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .zNavBar(NavigationBar(
            title: chore.title,
            leftItem: dismissButton,
            rightItem: EmptyView(),
            opacity: navBarOpacity
        ))
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
        VStack(alignment: .leading) {
            Text("\(chore.title)")
                .font(StylingFont.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Chore put up by: \(chore.assignerId)")
                .font(StylingFont.medium)
            Text("on \(chore.created.dateTimestamp.formatted(date: .abbreviated, time: .omitted))")
                .font(StylingFont.medium)
                .padding(.bottom)

            Text("Detail")
                .font(StylingFont.large)
            Text(chore.description)
                .padding(.bottom)

            if choreDetailViewModel.state.choreTaken {
                Text("Chore taken by: \(chore.assigneeId ?? "")")
                if choreDetailViewModel.state.choreFinished {
                    Text("Chore is completed on \(chore.finished!.dateTimestamp.formatted(date: .abbreviated, time: .omitted))")
                } else {
                    Text("Chore is not completed")
                }
            }
        }
        .padding(.horizontal)
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
