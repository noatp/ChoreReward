////
////  ChoreTabNavBarContainer.swift
////  ChoreReward
////
////  Created by Toan Pham on 3/22/22.
////
//
//import SwiftUI
//
//struct ChoreTabNavBarContainerView<Content: View>: View {
//    let pickerStateBinding: Binding<FinishedPickerState>
//    let content: Content
//    
//    init(
//        pickerStateBinding: Binding<FinishedPickerState>,
//        @ViewBuilder content: () -> Content
//    ) {
//        self.content = content()
//        self.pickerStateBinding = pickerStateBinding
//    }
//    
//    var body: some View {
//        VStack(spacing: 0){
//            ChoreTabNavBarView(pickerStateBinding: pickerStateBinding)
//            content
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
//}
//
//struct ChoreTabNavBarContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChoreTabNavBarContainerView(
//            pickerStateBinding: .constant(.unfinished)
//        ) {
//                Text("This is ChoreTabNavBarContainerView")
//        }
//        .preferredColorScheme(.dark)
//    }
//}
