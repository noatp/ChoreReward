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
    @Binding var presentedSheet: Bool
    @Environment(\.dismiss) var dismiss
    private var views: Dependency.Views
    
    init(
        addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>,
        presentedSheet: Binding<Bool>,
        views: Dependency.Views
    ){
        self.addChoreViewModel = addChoreViewModel
        self._presentedSheet = presentedSheet
        self.views = views
    }
    
    var body: some View {
        VStack{
            Spacer()
            TextFieldView(textInput: $choreTitle, title: "What chore?")
            Spacer()
            ButtonView(
                action: {
                    dismiss()
                },
                buttonTitle: "Create Chore",
                buttonImage: "plus",
                buttonColor: .accentColor
            
            )
            ButtonView(
                action: {presentedSheet = false},
                buttonTitle: "Cancel",
                buttonImage: "xmark.app",
                buttonColor: .red
            )
        }
    }
}

struct AddChoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddChoreView(
            addChoreViewModel: ObservableViewModel(
                staticState: AddChoreState()
            ),
            presentedSheet: .constant(false),
            views: Dependency.preview.views()
        )

    }
}

extension Dependency.Views{
    func addChoreView(presentedSheet: Binding<Bool>) -> AddChoreView{
        return AddChoreView(
            addChoreViewModel: ObservableViewModel(
                viewModel: viewModels.addChoreViewModel
            ),
            presentedSheet: presentedSheet,
            views: self
        )
    }
}
