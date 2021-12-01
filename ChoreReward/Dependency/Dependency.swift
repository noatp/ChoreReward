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
    
    class UseCases{
        let repositories: Repositories
        let services: Services
        
        init(
            repositories: Repositories,
            services: Services
        ){
            self.repositories = repositories
            self.services = services
        }
    }
    
    private func useCases() -> UseCases{
        return UseCases(
            repositories: self.repositories(),
            services: self.services()
        )
    }
    
    class ViewModels{
        let useCases: UseCases
        
        init(useCases: UseCases){
            self.useCases = useCases
        }
    }
    
    private func viewModels() -> ViewModels{
        return ViewModels(useCases: self.useCases())
    }
    
    class Views{
        let viewModels: ViewModels
        
        init(viewModels: ViewModels){
            self.viewModels = viewModels
        }
    }
    
    func views() -> Views{
        return Views(viewModels: self.viewModels())
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



