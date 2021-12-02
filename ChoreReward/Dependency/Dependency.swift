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
    static let preview = Dependency()
//
////    var recipeService: RecipeService
////    var database: Database
//    var mockData: MockData
//    var authService: AuthService
//
//    init(
//        mockData: MockData = MockData(),
//        authService: AuthService = AuthService()
//    ){
//        self.mockData = mockData
//        self.authService = authService
//    }
    
    class Services{
        let authService = AuthService()
    }
    
    private func services() -> Services{
        return Services()
    }
    
    class Repositories{
        let userRepository = UserRepository()
    }
    
    private func repositories() -> Repositories{
        return Repositories()
    }
    
    class ViewModels{
        let services: Services
        let repositories: Repositories
        init(
            services: Services,
            repositories: Repositories
        ){
            self.services = services
            self.repositories = repositories
        }
    }
    
    private func viewModels() -> ViewModels{
        return ViewModels(
            services: services(),
            repositories: repositories()
        )
    }
    
    class Views{
        let viewModels: ViewModels
        
        init(viewModels: ViewModels){
            self.viewModels = viewModels
        }
    }
    
    func views() -> Views{
        return Views(viewModels: viewModels())
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



