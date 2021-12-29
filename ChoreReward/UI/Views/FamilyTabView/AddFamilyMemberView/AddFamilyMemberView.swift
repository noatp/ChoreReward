//
//  AddFamilyMemberView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/28/21.
//

import SwiftUI

struct AddFamilyMemberView: View {
    @ObservedObject var addFamilyMemberViewModel: AddFamilyMemberViewModel
    private var views: Dependency.Views
    
    init(
        addFamilyMemberViewModel: AddFamilyMemberViewModel,
        views: Dependency.Views
    ){
        self.addFamilyMemberViewModel = addFamilyMemberViewModel
        self.views = views
    }
    
    var body: some View {
        VStack(spacing: 16){
            Text("You need the UserID to add them to your family")
            TextFieldView(textFieldViewModel: addFamilyMemberViewModel.userIdInputRender)
            Button("Add Member") {
                addFamilyMemberViewModel.addMember()
            }
        }
        .padding()
    }
}

struct AddFamilyMemberView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().addFamilyMemberView

    }
}

extension Dependency.Views{
    var addFamilyMemberView: AddFamilyMemberView{
        return AddFamilyMemberView(
            addFamilyMemberViewModel: viewModels.addFamilyMemberViewModel,
            views: self
        )
    }
}
