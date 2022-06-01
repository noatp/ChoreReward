//
//  RolePickerView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/5/21.
//

import SwiftUI

struct RolePickerView: View {
    @Binding var roleSelection: Role

    init(
        roleSelection: Binding<Role>
    ) {
        self._roleSelection = roleSelection
    }

    var body: some View {
        HStack {
            Text("You are a: ")
            Picker("Role", selection: $roleSelection) {
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
        RolePickerView(roleSelection: .constant(.parent))
    }
}
