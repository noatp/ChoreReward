//
//  AddChoreView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import SwiftUI

// MARK: Main Implementaion

struct AddChoreView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>
    @State var choreTitle = ""
    @State var choreRewardValue = ""
    @State var choreDescription = ""
    @State var isPresentingImagePicker = false
    @State var choreImageUrl: String?
    @FocusState private var focusedField: AddChoreFields?
    private var views: Dependency.Views

    init(
        addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>,
        views: Dependency.Views
    ) {
        self.addChoreViewModel = addChoreViewModel
        self.views = views
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    if let choreImageUrl = choreImageUrl {
                        RemoteImageView(imageUrl: choreImageUrl, isThumbnail: false)
                            .frame(maxWidth: proxy.size.width, minHeight: 200, maxHeight: 300)
                            .clipped()
                            .smallVerticalPadding()
                            .onTapGesture {
                                isPresentingImagePicker = true
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray)
                            .frame(maxWidth: proxy.size.width, minHeight: 200, maxHeight: 300)
                            .foregroundColor(.clear)
                            .shadow(radius: 1)
                            .overlay {
                                Text("Add photo").foregroundColor(.accentGraySecondary)
                            }
                            .smallVerticalPadding()
                            .onTapGesture {
                                isPresentingImagePicker = true
                            }
                    }

                    TextFieldView(title: "Title", textInput: $choreTitle)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .title)
                        .onSubmit {
                            focusedField = .rewardValue
                        }

                    TextFieldView(title: "Reward", textInput: $choreRewardValue)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .rewardValue)
                        .onSubmit {
                            focusedField = .description
                        }

                    TextEditorView(title: "Description", textInput: $choreDescription)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .description)
                        .onSubmit {
                            focusedField = .none
                        }

                    addButton
                    Spacer()
                }
                .frame(height: proxy.size.height)
            }
        }
        .padding()
        .vNavBar(NavigationBar(
            title: "Add chore",
            leftItem: dismissButton,
            rightItem: addButton
        ))
        .sheet(isPresented: $isPresentingImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { newChoreImageUrl in
                choreImageUrl = newChoreImageUrl
            }
        }
    }
}

// MARK: Preview

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

// MARK: Add to Dependency

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

// MARK: Subviews

extension AddChoreView {
    private var dismissButton: some View {
        CircularButton(action: {
            dismiss()
        }, icon: "xmark")
    }

    private var addButton: some View {
        RegularButton(buttonTitle: "Done") {
            addChoreAndDismiss()
        }
        .disabled(choreTitle.isEmpty || choreDescription.isEmpty || choreRewardValue.isEmpty || choreImageUrl == nil)
    }
}

// MARK: Additional functionality

extension AddChoreView {
    private func addChoreAndDismiss() {
        dismiss()
        addChoreViewModel.perform(
            action: .createChore(
                choreTitle: choreTitle,
                choreDescription: choreDescription,
                choreImageUrl: choreImageUrl!,
                choreRewardValue: choreRewardValue)
        )
    }

    private enum AddChoreFields: Int, Hashable {
        case title, rewardValue, description
    }
}
