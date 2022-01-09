//
//  AddFamilyMemberView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/7/22.
//

import SwiftUI

struct AddFamilyMemberView: View {
    @ObservedObject var addFamilyMemberViewModel: ObservableViewModel<Void, AddFamilyMemberAction>
    private var views: Dependency.Views
    @State var userIdInput = ""
    init(
        addFamilyMemberViewModel: ObservableViewModel<Void, AddFamilyMemberAction>,
        views: Dependency.Views
    ){
        self.addFamilyMemberViewModel = addFamilyMemberViewModel
        self.views = views
    }
    
    var body: some View {
        VStack(spacing: 16){
            Text("You need the UserID to add them to your family")
                .font(.footnote)
            TextFieldView(
                textInput: $userIdInput,
                title: "UserID"
            )
            ButtonView(
                action: {addFamilyMemberViewModel.perform(action: .addMember(userId: self.userIdInput))},
                buttonTitle: "Add member",
                buttonImage: "person.badge.plus",
                buttonColor: .accentColor
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
    var addFamilyMemberView: AddFamilyMemberView{
        return AddFamilyMemberView(
            addFamilyMemberViewModel: ObservableViewModel(
                viewModel: viewModels.addFamilyMemberViewModel
            ),
            views: self
        )
    }
}
