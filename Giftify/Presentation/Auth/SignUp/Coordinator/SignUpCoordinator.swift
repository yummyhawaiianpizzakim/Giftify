//
//  SignUpCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/08/01.
//

import Foundation
import UIKit

class SignUpCoordinator: CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var type: CoordinatorType = .signUp
    
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        self.showSignUpView()
    }
    
    func showSignUpView() {
        let container = DIContainer.shared.container
        
        guard let vm = container.resolve(SignUpViewModel.self) else { return }
        
        let vc = SignUpViewController(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
}
