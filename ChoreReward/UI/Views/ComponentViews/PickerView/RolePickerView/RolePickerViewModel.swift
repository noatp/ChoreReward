//
//  RolePickerViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/5/21.
//

import Foundation

class RolePickerViewModel: ObservableObject{
    @Published var selection: Role = .parent
    
    static let preview = RolePickerViewModel()
}
