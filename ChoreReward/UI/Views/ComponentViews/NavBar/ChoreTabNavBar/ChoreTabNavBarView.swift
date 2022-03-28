//
//  ChoreTabNavBar.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/22/22.
//

import SwiftUI

enum FinishedPickerState{
    case finished, unfinished
}

struct ChoreTabNavBarView: View {
    @Environment(\.presentingSideDrawer) @Binding var presentingSideDrawer: Bool
    @Binding var pickerStateBinding: FinishedPickerState
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Button {
                    withAnimation {
                        presentingSideDrawer = true
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
                .foregroundColor(.fg)

                Text("Chore")
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.title)
                    .foregroundColor(.fg)
            }
            
            HStack{
                HStack(spacing: 0){
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            pickerStateBinding = .unfinished
                        }
                    } label: {
                        Text("Unfinished")
                            .foregroundColor(.fg)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background{
                        if (pickerStateBinding == .unfinished){
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundColor(.bg3)
                                .matchedGeometryEffect(id: "pickerBackground", in: animation)
                        }
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            pickerStateBinding = .finished
                        }
                    } label: {
                        Text("Finished")
                            .foregroundColor(.fg)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background{
                        if (pickerStateBinding == .finished){
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundColor(.bg3)
                                .matchedGeometryEffect(id: "pickerBackground", in: animation)
                        }
                    }
                }
                .background{
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundColor(.bg2)
                }
                
                Spacer()
            }
           

        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(Color.bg.ignoresSafeArea(edges: .top))
    }
}

struct ChoreTabNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top){
            Text("This is NavBarView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray)
            ChoreTabNavBarView(
                pickerStateBinding: .constant(.unfinished)
            )
        }
        .preferredColorScheme(.dark)
    }
}
