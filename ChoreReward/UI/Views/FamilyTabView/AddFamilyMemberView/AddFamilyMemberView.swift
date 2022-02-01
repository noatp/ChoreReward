//
//  AddFamilyMemberView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/7/22.
//

import SwiftUI

struct AddFamilyMemberView: View {
    @ObservedObject var addFamilyMemberViewModel: ObservableViewModel<Void, AddFamilyMemberAction>
    @State var userIdInput = ""
    @Environment(\.dismiss) var dismiss
    private var views: Dependency.Views
    init(
        addFamilyMemberViewModel: ObservableViewModel<Void, AddFamilyMemberAction>,
        views: Dependency.Views
    ){
        self.addFamilyMemberViewModel = addFamilyMemberViewModel
        self.views = views
    }
    
    var body: some View {
        VStack(spacing: 16){
            Spacer()
            Text("Please input the UserID of the new member")
                .font(.footnote)
            TextFieldView(
                textInput: $userIdInput,
                title: "UserID"
            )
            Spacer()
            ButtonView(
                action: {
                    dismiss()
                    addFamilyMemberViewModel.perform(action: .addMember(userId: self.userIdInput))
                },
                buttonTitle: "Add member",
                buttonImage: "person.badge.plus",
                buttonColor: .accentColor
            )
            ButtonView(
                action: {
                    dismiss()
                },
                buttonTitle: "Cancel",
                buttonImage: "xmark.app",
                buttonColor: .red
            )
        }
        .navigationTitle("Add new member")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct AddFamilyMemberView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddFamilyMemberView(
                addFamilyMemberViewModel: ObservableViewModel(
                    staticState: ()
                ),
                views: Dependency.preview.views()
            )

        }
    }
}

extension Dependency.Views{
    func addFamilyMemberView() -> AddFamilyMemberView{
        return AddFamilyMemberView(
            addFamilyMemberViewModel: ObservableViewModel(
                viewModel: viewModels.addFamilyMemberViewModel
            ),
            views: self
        )
    }
}
