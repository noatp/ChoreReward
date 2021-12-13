//
//  FamilyTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct FamilyTabView: View {
    @ObservedObject var familyTabViewModel: FamilyTabViewModel
    private var views: Dependency.Views
    
    init(
        familyTabViewModel: FamilyTabViewModel,
        views: Dependency.Views
    ){
        self.familyTabViewModel = familyTabViewModel
        self.views = views
    }
    var body: some View {
        HStack{
            if (familyTabViewModel.currentFamily != nil){
                Text("Has family")
            }
            else{
                VStack{
                    Button("Create a new family") {
                        familyTabViewModel.createFamily()
                    }
                    .padding()
                    Button("Join an existing family"){
                        
                    }
                    .padding()
                }
                
            }
        }
        .onAppear {
            familyTabViewModel.readCurrentFamily()
        }
    }
}

struct FamilyTabView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().familyTabView
    }
}

extension Dependency.Views{
    var familyTabView: FamilyTabView{
        return FamilyTabView(
            familyTabViewModel: viewModels.familyTabViewModel,
            views: self
        )
    }
}
