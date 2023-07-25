//
//  AppCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    

    weak var finishDelegate: CoordinatorFinishDelegate?

    var childCoordinators: [CoordinatorProtocol] = []

    var type: CoordinatorType = .app

    let container = DIContainer.shared.container
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        self.showTabBarFlow()
    }

}

extension AppCoordinator {
    func showTabBarFlow() {
        let navigation = UINavigationController()
        self.window?.rootViewController = navigation
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigation)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
        
        self.window?.makeKeyAndVisible()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        self.childCoordinators = childCoordinators.filter({ coordinator in
            coordinator.type != childCoordinator.type
        })
    }
}
