//
//  SignInCoordinator.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/31.
//

import Foundation
import UIKit

class SignInCoordinator: CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var type: CoordinatorType = .signIn
    
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        self.showSignInView()
    }
    
    func showSignInView() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(SignInViewModel.self) else { return }
        vm.setActions(
            actions: SignInViewModelActions(
                showSignUpView: self.showSignUpView,
                closeSignInView: self.closeSignInView
            )
        )
        let vc = SignInViewController(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: false)
    }
    
    lazy var showSignUpView: () -> Void = { [weak self] in
        let signUpCoordinator = SignUpCoordinator(navigation: self!.navigation)
        self?.childCoordinators.append(signUpCoordinator)
        signUpCoordinator.finishDelegate = self
        signUpCoordinator.start()
        
    }
    
    lazy var closeSignInView: () -> Void = { [weak self] in
        self?.finish()
        self?.navigation.popViewController(animated: true)
    }
}

extension SignInCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
