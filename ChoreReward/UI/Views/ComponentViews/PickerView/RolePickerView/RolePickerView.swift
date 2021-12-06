//
//  RolePickerView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/5/21.
//

import SwiftUI

struct RolePickerView: View {
    @ObservedObject private var rolePickerViewModel: RolePickerViewModel
    
    init(
        rolePickerViewModel: RolePickerViewModel
    ){
        self.rolePickerViewModel = rolePickerViewModel
    }
    
    var body: some View {
        HStack{
            Text("You are a: ")
            Picker("Role", selection: $rolePickerViewModel.selection) {
                Text("Parent").tag(Role.parent)
                Text("Child").tag(Role.child)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        
    }
}

struct RolePickerView_Previews: PreviewProvider {
    static var previews: some View {
        RolePickerView(rolePickerViewModel: RolePickerViewModel.preview)
    }
}
