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
            imagePickerButton

            TextFieldView(title: "Title", textInput: $choreTitle)

            TextFieldView(title: "Reward", textInput: $choreRewardValue)

            TextEditorView(title: "Description", textInput: $choreDescription)

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
        .padding()
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
        .font(StylingFont.regular)
        .previewLayout(.sizeThatFits)
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
    private var dismissButton: some View {
        CircularButton(action: {
            dismiss()
        }, icon: "xmark")
    }

    private var imagePickerButton: some View {
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
                }

            }
        }
        .shadow(radius: 1)
        .smallVerticalPadding()
        .onTapGesture {
            isPresentingImagePicker = true
        }
    }
}
