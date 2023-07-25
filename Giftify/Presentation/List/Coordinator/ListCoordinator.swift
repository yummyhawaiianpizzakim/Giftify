//
//  ListCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import UIKit
import RxRelay

class ListCoordinator: CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var type: CoordinatorType = .list
    
    var navigation: UINavigationController
    
    init(navigation : UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        self.showListView()
    }
    
    private func showListView() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(ListViewModel.self) else { return }
        
        let vc = ListViewController(viewModel: vm)
        
//        vm.setActions(
//            actions: PhotoListViewModelActions(
//                showPhotoDetail: self.showPhotoDetail
//            )
//        )
        
        self.navigation.pushViewController(vc, animated: true)
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

extension ListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
    
    
}
