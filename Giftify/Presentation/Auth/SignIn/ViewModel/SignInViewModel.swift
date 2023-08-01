//
//  SignInViewModel.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/31.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxRelay

struct SignInViewModelActions {
    let showSignUpView: () -> Void
    let closeSignInView: () -> Void
}

class SignInViewModel {
    var signInUseCase: SignInUseCaseProtocol
    let disposeBag = DisposeBag()
    
    var actions: SignInViewModelActions?
    
    
    init(signInUseCase: SignInUseCaseProtocol) {
        self.signInUseCase = signInUseCase
    }
    
    
    func setActions(actions: SignInViewModelActions) {
        self.actions = actions
    }
    
//    struct Input {
//
//    }
//
//    struct Output {
//
//    }
//
//    func transform(input: Input) -> Output {
//        let output = Output()
//
//        return output
//    }
}

extension SignInViewModel {
    func signIn(credential: AuthCredential) {
        self.signInUseCase.signIn(credential: credential)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .signIn:
                    owner.actions?.closeSignInView()
//                    print("success signIn")
                case .signUp:
                    owner.signInUseCase.createUser()
                        .subscribe(onSuccess: { _ in
                            owner.actions?.closeSignInView()
//                            print("success signUp")
                        }, onFailure: { error in
                            print(error)
                        }).disposed(by: owner.disposeBag)
                case .failure:
                    print("signIn error!")
                }
            })
            .disposed(by: self.disposeBag)
    }
}
