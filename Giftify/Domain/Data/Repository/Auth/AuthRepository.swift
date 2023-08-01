//
//  SignIn.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/31.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol AuthRepositoryProtocol {
    func signIn(credential: AuthCredential) -> Single<Bool>
    func checkUserRegistered() -> Single<Bool>
    func createUser() -> Single<Bool> 
}

class AuthRepository: AuthRepositoryProtocol {
    var fireBaseNetworkService: FireBaseNetworkServiceProtocol
    let disposeBag = DisposeBag()
    
    init(fireBaseNetworkService: FireBaseNetworkServiceProtocol) {
        self.fireBaseNetworkService = fireBaseNetworkService
    }
    
    func signIn(credential: AuthCredential) -> Single<Bool> {
        return self.fireBaseNetworkService.signIn(credential: credential)
    }
    
    func checkUserRegistered() -> Single<Bool> {
        return self.fireBaseNetworkService.checkUserRegistered()
            .map({ Bool in
                print(Bool)
                return Bool
            })
            .catchAndReturn(false)

    }
    
    func createUser() -> Single<Bool> {
        return self.fireBaseNetworkService.signUp()
    }
}
