//
//  AddGifticonCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
import UIKit

class AddGifticonCoordinator: CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var type: CoordinatorType = .addGifticon
    
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    init() {
        self.navigation = .init()
    }
    
    func start() {
        self.showAddGifticonView()
    }
}

private extension AddGifticonCoordinator {
    func showAddGifticonView() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(AddGifticonViewModel.self) else { return }
        let vc = AddGifticonViewController(viewModel: vm)
//        self.navigation.modalPresentationStyle = .fullScreen
//        self.navigation.present(vc, animated: true)
        self.navigation.pushViewController(vc, animated: true)
    }
}
