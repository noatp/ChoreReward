//
//  Dependency.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/28/21.
//

import Foundation
import UIKit

class Dependency{
    
    static let shared = Dependency()
    static let preview = Dependency(mockData: MockData())
    
//    var recipeService: RecipeService
//    var database: Database
    var mockData: MockData
    var authService: AuthService
    
    init(
        mockData: MockData = MockData(),
        authService: AuthService = AuthService()
    ){
        self.mockData = mockData
        self.authService = authService
    }
    
}

//class MockRecipeService: RecipeService{
//    init(
//        isLoading: Bool = false,
//        moreRecipeAvailable: Bool = false
//    ) {
//        super.init(
//            initFetchRecipesState: FetchRecipesState(
//                isLoading: isLoading,
//                moreRecipeAvailable: moreRecipeAvailable,
//                recipeList: Recipe.previewList
//            )
//        )
//    }
//}
//
//class MockDatabase: Database{
//
//}


