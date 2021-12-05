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
    
    class Repositories{
        let userRepository = UserRepository()
    }
    
    private func repositories() -> Repositories{
        return Repositories()
    }
    
    class Services{
        let authService = AuthService()
        let repositories: Repositories
        
        init(repositories: Repositories){
            self.repositories = repositories
        }
    }
    
    private func services() -> Services{
        return Services(repositories: repositories())
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



