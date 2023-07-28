//
//  HomeCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import UIKit
import RxRelay

class HomeCoordinator: CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var type: CoordinatorType = .home
    
    var navigation: UINavigationController
    
    init(navigation : UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        self.showHomeView()
    }
    
    private func showHomeView() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(HomeViewModel.self) else { return }
        
        let vc = HomeViewController(viewModel: vm)
        
        vm.setActions(
            actions: HomeViewModelActions(
                showAddGifticonView: self.showAddGifticonView
            )
        )
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    lazy var showAddGifticonView: () -> Void = { [weak self] in
//        let navigation = UINavigationController()
        let addGifticonCoordinator = AddGifticonCoordinator(navigation: self!.navigation)
//        let addGifticonCoordinator = AddGifticonCoordinator()
        addGifticonCoordinator.finishDelegate = self
        self?.childCoordinators.append(addGifticonCoordinator)
        addGifticonCoordinator.start()
        
    }
    
//    lazy var showPhotoDetail: (_ IndexPath: IndexPath) -> Void = { [weak self] indexPath in
//        let container = DIContainer.shared.container
//        guard let vm = container.resolve(PhotoDetailViewModel.self) else { return }
//        vm.indexpath = indexPath
//        let vc = PhotoDetailViewController(viewModel: vm)
////        self?.navigation.present(vc, animated: true)
//        self?.navigation.pushViewController(vc, animated: true)
//    }
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
    
    
}
