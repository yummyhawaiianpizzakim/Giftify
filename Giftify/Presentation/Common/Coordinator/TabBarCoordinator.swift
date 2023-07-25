//
//  TabBarCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import UIKit

enum TabBarPage: Int, CaseIterable {
    case home = 0
    case list = 1
    case setting = 2
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return ""
        case .list:
            return ""
        case .setting:
            return ""
        }
    }
    
    func pageTabIcon() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .list:
            return UIImage(systemName: "list.bullet")
        case .setting:
            return UIImage(systemName: "gearshape")
        }
    }
}

class TabBarCoordinator: CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [CoordinatorProtocol] = []
    var type: CoordinatorType = .tab
    var navigationController: UINavigationController
    private var tabBarController: UITabBarController
    private var currentPage: TabBarPage = .home
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.unselectedItemTintColor = .black
    }
    
    func start() {
        let pages = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map { TabBarPage in
            self.getController(page: TabBarPage)
        }
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.prepareTabBarController(controllers: controllers)
    }
    
}

extension TabBarCoordinator {
    private func prepareTabBarController(controllers: [UIViewController]) {
        self.tabBarController.setViewControllers(controllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.rawValue
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .systemBackground
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getController(page: TabBarPage) -> UINavigationController {
        let navigation = UINavigationController()
        
        navigation.tabBarItem = UITabBarItem.init(
            title: page.pageTitleValue(),
            image: page.pageTabIcon(),
            tag: page.rawValue
        )
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigation: navigation)
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .list:
            let listCoordinator = ListCoordinator(navigation: navigation)
            listCoordinator.finishDelegate = self
            self.childCoordinators.append(listCoordinator)
            listCoordinator.start()
        case .setting:
            let settingCoordinator = SettingCoordinator(navigation: navigation)
            settingCoordinator.finishDelegate = self
            self.childCoordinators.append(settingCoordinator)
            settingCoordinator.start()
        }
        
        return navigation
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        self.childCoordinators = self.childCoordinators.filter({ Coordinator in
            Coordinator.type != childCoordinator.type
        })
    }
}

