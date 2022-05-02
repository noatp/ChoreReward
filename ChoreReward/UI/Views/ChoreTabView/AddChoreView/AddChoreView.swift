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
    @State var choreDescription = ""
    @Environment(\.dismiss) var dismiss
    private var views: Dependency.Views
    
    init(
        addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>,
        views: Dependency.Views
    ){
        self.addChoreViewModel = addChoreViewModel
        self.views = views
    }
    
    var body: some View {
        VStack{
            Spacer()
            TextFieldView(textInput: $choreTitle, title: "What chore?")
            Spacer()
            TextFieldView(textInput: $choreDescription, title: "Description")
            Spacer()
            ButtonView(buttonTitle: "Create Chore", buttonImage: "plus") {
                dismiss()
                addChoreViewModel.perform(
                    action: .createChore(choreTitle: choreTitle, choreDescription: choreDescription)
                )
            }
            ButtonView(buttonTitle: "Cancel", buttonImage: "xmark.app") {
                dismiss()
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

    }
}

extension Dependency.Views{
    func addChoreView() -> AddChoreView{
        return AddChoreView(
            addChoreViewModel: ObservableViewModel(
                viewModel: viewModels.addChoreViewModel
            ),
            views: self
        )
    }
}
