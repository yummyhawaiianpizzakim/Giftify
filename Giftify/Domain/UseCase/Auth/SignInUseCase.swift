//
//  SignInUseCase.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/31.
//

import Foundation
import FirebaseAuth
import RxSwift

enum SignInResult {
    case signIn
    case signUp
    case failure
}

protocol SignInUseCaseProtocol {
    func signIn(credential: AuthCredential) -> Observable<SignInResult>
    func createUser() -> Single<Bool> 
}

class SignInUseCase: SignInUseCaseProtocol {
    var authRepository: AuthRepositoryProtocol
    let disposeBag = DisposeBag()
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func signIn(credential: AuthCredential) -> Observable<SignInResult> {
        return Observable<SignInResult>.create {[weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            self.authRepository.signIn(credential: credential)
                .subscribe(onSuccess: { bool in
//                    print("usecase signIn \(bool)")
                    self.authRepository.checkUserRegistered()
                        .subscribe(onSuccess: { Bool in
//                            print("usecase checkUserRegistered \(bool)")
                            Bool ? observer.onNext(.signIn) : observer.onNext(.signUp)
                        })
                        .disposed(by: self.disposeBag)
                    
                }, onFailure: { error in
                    observer.onNext(.failure)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
    
    func createUser() -> Single<Bool> {
        return self.authRepository.createUser()
    }
}
