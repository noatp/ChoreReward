//
//  AddChoreView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import SwiftUI
import Combine

// MARK: Main Implementaion

struct AddChoreView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var addChoreViewModel: ObservableViewModel<Void, AddChoreAction>
    @State var choreTitle = ""
    @State var choreRewardValue = ""
    @State var choreDescription = ""
    @State var isPresentingImagePicker = false
    @State var choreImageUrl: String?
    @State var shouldShowAlert: Bool = false
    @FocusState private var focusedField: AddChoreFields?
    private var views: Dependency.Views

    init(
        addChoreViewModel: ObservableViewModel<Void, AddChoreAction>,
        views: Dependency.Views
    ) {
        self.addChoreViewModel = addChoreViewModel
        self.views = views
    }

    var body: some View {

        Form {
            if let choreImageUrl = choreImageUrl {
                RemoteImage(imageUrl: choreImageUrl, isThumbnail: false)
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
                    .clipped()
                    .smallVerticalPadding()
                    .onTapGesture {
                        isPresentingImagePicker = true
                    }
            } else {
                RegularButton(buttonTitle: "Add photo", buttonImage: "plus") {
                    isPresentingImagePicker = true
                }
            }
            RegularTextField(title: "Title", textInput: $choreTitle)
                .submitLabel(.next)
                .focused($focusedField, equals: .title)
                .onSubmit {
                    focusedField = .rewardValue
                }
            HStack {
                Text("$")
                RegularTextField(title: "Reward amount", textInput: $choreRewardValue)
                    .keyboardType(.numberPad)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .rewardValue)
                    .onSubmit {
                        focusedField = .description
                    }
            }

            Section("Description", content: {
                TextEditor(text: $choreDescription)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .description)
                    .onSubmit {
                        focusedField = .none
                    }
            })
        }
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
        .alert(
            "Please fill out all information.",
            isPresented: $shouldShowAlert) {
                RegularButton(buttonTitle: "OK", action: {})
            }
    }
}

// MARK: Preview

struct AddChoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddChoreView(
            addChoreViewModel: ObservableViewModel(staticState: nil),
            views: Dependency.preview.views()
        )
        .font(StylingFont.regular)
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
            if missingInfo() {
                shouldShowAlert = true
                return
            }
            addChoreAndDismiss()
        }
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

    private func missingInfo() -> Bool {
        return choreTitle.isEmpty || choreDescription.isEmpty || choreRewardValue.isEmpty || choreImageUrl == nil
    }

    private enum AddChoreFields: Int, Hashable {
        case title, rewardValue, description
    }

}
