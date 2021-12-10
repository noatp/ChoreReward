//
//  FamilyCreateView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/10/21.
//

import SwiftUI

struct FamilyCreateView: View {
    @ObservedObject var familyCreateViewModel: FamilyCreateViewModel
    private var views: Dependency.Views
    
    init(
        familyCreateViewModel: FamilyCreateViewModel,
        views: Dependency.Views
    ){
        self.familyCreateViewModel = familyCreateViewModel
        self.views = views
    }
    
    var body: some View {
        Text("FamilyCreateView")
    }
}

struct FamilyCreateViewPreviews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().familyCreateView
    }
}

extension Dependency.Views{
    var familyCreateView: FamilyCreateView{
        return FamilyCreateView(
            familyCreateViewModel: viewModels.familyCreateViewModel,
            views: self
        )
    }
}
