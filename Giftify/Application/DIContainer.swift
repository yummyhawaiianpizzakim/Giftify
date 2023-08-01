//
//  DIContainer.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import Swinject

class DIContainer {
    static let shared = DIContainer()
    
    let container = Container()
    
    private init() {
        registerInfraStructure()
        registerService()
        registerRepository()
        registerUseCase()
        registerViewModel()
    }
    
    func registerInfraStructure() {
        self.registerFireBaseNetworkService()
    }
    
    func registerService() {
    }
    
    func registerRepository() {
        self.registerAuthRepository()
    }
    
    func registerUseCase() {
        self.registerSignInUseCase()
    }
    
    func registerViewModel() {
        self.registerHomeViewModel()
        self.registerListViewModel()
        self.registerSettingViewModel()
        self.registerAddGifticonViewModel()
        self.registerSignInViewModel()
        self.registerSignUpViewModel()
    }
}

extension DIContainer {
    func registerFireBaseNetworkService() {
        self.container.register(FireBaseNetworkServiceProtocol.self) { resolver in
            return FireBaseNetworkService()
        }
        .inObjectScope(.container)
    }
}

extension DIContainer {
    
}

extension DIContainer {
    func registerAuthRepository() {
        self.container.register(AuthRepositoryProtocol.self) { resolver in
            let fireBaseNetworkService = resolver.resolve(FireBaseNetworkServiceProtocol.self)
            return AuthRepository(fireBaseNetworkService: fireBaseNetworkService!)
        }
        .inObjectScope(.container)
    }
}

extension DIContainer {
    func registerSignInUseCase() {
        self.container.register(SignInUseCaseProtocol.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryProtocol.self)
            return SignInUseCase(authRepository: authRepository!)
        }
        .inObjectScope(.container)
    }
}

extension DIContainer {
    func registerHomeViewModel() {
        self.container.register(HomeViewModel.self) { resolver in
            return HomeViewModel()
        }
        .inObjectScope(.graph)
    }
    
    func registerListViewModel() {
        self.container.register(ListViewModel.self) { resolver in
            return ListViewModel()
        }
        .inObjectScope(.graph)
    }
    
    func registerSettingViewModel() {
        self.container.register(SettingViewModel.self) { resolver in
            return SettingViewModel()
        }
        .inObjectScope(.graph)
    }
    
    func registerAddGifticonViewModel() {
        self.container.register(AddGifticonViewModel.self) { resolver in
            return AddGifticonViewModel()
        }
        .inObjectScope(.graph)
    }
    
    func registerSignInViewModel() {
        self.container.register(SignInViewModel.self) { resolver in
            let signInUseCase = resolver.resolve(SignInUseCaseProtocol.self)
            return SignInViewModel(signInUseCase: signInUseCase!)
        }
        .inObjectScope(.graph)
    }
    
    func registerSignUpViewModel() {
        self.container.register(SignUpViewModel.self) { resolver in
            
            return SignUpViewModel()
        }
        .inObjectScope(.graph)
    }
}
