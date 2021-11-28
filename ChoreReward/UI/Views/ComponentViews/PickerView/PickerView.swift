//
//  PickerView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/5/21.
//

//import SwiftUI
//
//struct PickerView<T>: View where T: Hashable, Identifiable {
//    @ObservedObject private var pickerViewModel: PickerViewModel<T>
//    
//    init(pickerViewModel: PickerViewModel<T>) {
//        self.pickerViewModel = pickerViewModel
//    }
//    
//    var body: some View {
//        Picker(pickerViewModel.title, selection: $pickerViewModel.selected) {
//            ForEach(pickerViewModel.options) { option in
//                Text(option.rawValue.capitalized)
//            }
//        }
//    }
//}
//
//struct PickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PickerView(pickerViewModel: PickerViewModel.preview)
//    }
//}
