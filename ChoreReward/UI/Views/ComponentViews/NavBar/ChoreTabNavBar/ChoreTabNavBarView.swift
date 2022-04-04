////
////  ChoreTabNavBar.swift
////  ChoreReward
////
////  Created by Toan Pham on 3/22/22.
////
//
//import SwiftUI
//
//enum FinishedPickerState{
//    case finished, unfinished
//}
//
//struct ChoreTabNavBarView: View {
//    @Environment(\.presentingSideDrawer) @Binding var presentingSideDrawer: Bool
//    @Binding var pickerStateBinding: FinishedPickerState
//    @Namespace private var animation
//    
//    var body: some View {
//        VStack(alignment: .leading){
//            HStack{
//                Button {
//                    presentingSideDrawer = true
//                } label: {
//                    Image(systemName: "line.3.horizontal")
//                }
//                .foregroundColor(.fg)
//
//                Text("Chore")
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//                    .font(.title)
//                    .foregroundColor(.fg)
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//        .padding(.bottom)
//        .background(Color.bg.ignoresSafeArea(edges: .top))
//    }
//}
//
//struct ChoreTabNavBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack(alignment: .top){
//            Text("This is NavBarView")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(.gray)
//            ChoreTabNavBarView(
//                pickerStateBinding: .constant(.unfinished)
//            )
//        }
//        .preferredColorScheme(.dark)
//    }
//}
