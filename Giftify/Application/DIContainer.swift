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
    }
    
    func registerService() {
    }
    
    func registerRepository() {
    }
    
    func registerUseCase() {
    }
    
    func registerViewModel() {
        self.registerHomeViewModel()
        self.registerListViewModel()
        self.registerSettingViewModel()
        self.registerAddGifticonViewModel()
    }
}

extension DIContainer {
    
}

extension DIContainer {
    
}

extension DIContainer {
    
}

extension DIContainer {
    
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
}
