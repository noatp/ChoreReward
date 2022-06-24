//
//  AddChoreView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import SwiftUI

struct AddChoreView: View {
    @ObservedObject var addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>
    @State var choreTitle = ""
    @State var choreRewardValue = ""
    @State var choreDescription = ""
    @State var isPresentingImagePicker = false
    @State var choreImageUrl: String?
    @Environment(\.dismiss) var dismiss
    private var views: Dependency.Views

    init(
        addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>,
        views: Dependency.Views
    ) {
        self.addChoreViewModel = addChoreViewModel
        self.views = views
    }

    var body: some View {
        VStack {
            Group {
                if let choreImageUrl = choreImageUrl {
                    RemoteImageView(imageUrl: choreImageUrl, isThumbnail: false)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .foregroundColor(.textFieldPlaceholder)

                        Text("Add photo")
                            .font(StylingFont.regular)
                    }

                }
            }
            .shadow(radius: 1)
            .padding([.horizontal, .bottom])
            .onTapGesture {
                isPresentingImagePicker = true
            }

            TextFieldView(title: "Title", textInput: $choreTitle)
                .padding([.horizontal, .bottom])
            TextFieldView(title: "Reward", textInput: $choreRewardValue)
                .padding([.horizontal, .bottom])
            ZStack(alignment: .leading) {
                TextEditor(text: $choreDescription)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 1)
                if choreDescription.isEmpty {
                    VStack {
                        Text("Description")
                            .foregroundColor(.textFieldPlaceholder)
                            .padding(.all, 8)

                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: 200)
            Spacer()
            if let choreImageUrl = choreImageUrl {
                RegularButtonView(buttonTitle: "Create Chore", buttonImage: "plus") {
                    dismiss()
                    addChoreViewModel.perform(
                        action: .createChore(
                            choreTitle: choreTitle,
                            choreDescription: choreDescription,
                            choreImageUrl: choreImageUrl,
                            choreRewardValue: choreRewardValue)
                    )
                }
                .padding()
            }
        }
        .vNavBar(NavigationBar(
            title: "Add chore",
            leftItem: dismissButton,
            rightItem: EmptyView()
        ))
        .sheet(isPresented: $isPresentingImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { newChoreImageUrl in
                choreImageUrl = newChoreImageUrl
            }
        }
    }
}

struct AddChoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddChoreView(
            addChoreViewModel: ObservableViewModel(
                staticState: AddChoreState()
            ),
            views: Dependency.preview.views()
        )

        AddChoreView(
            addChoreViewModel: ObservableViewModel(
                staticState: AddChoreState()
            ),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
    }
}

extension Dependency.Views {
    func addChoreView() -> AddChoreView {
        return AddChoreView(
            addChoreViewModel: ObservableViewModel(
                viewModel: viewModels.addChoreViewModel
            ),
            views: self
        )
    }
}

extension AddChoreView {
    var dismissButton: some View {
        CircularButton(action: {
            dismiss()
        }, icon: "xmark")
    }
}
