//
//  FireBaseNetworkService.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/31.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxSwift
import RxRelay

enum NetworkServiceError: Error {
    case noNetworkService // NetworkService X
    case noAuthError // uid X
    case permissionDenied // wrong access
    case needFilterError
    case noUrlError
    case noDataError
}

enum Access {
    case user
    case gifticon
    
    var path: String {
        switch self {
        case .user:
            return "user"
        case .gifticon:
            return "gifticon"
        }
    }
}

protocol FireBaseNetworkServiceProtocol {
    func signIn(credential: AuthCredential) -> Single<Bool>
    func signOut() -> Single<Bool> 
    func signUp() -> Single<Bool>
    func checkUserRegistered() -> Single<Bool>
    func create<T: DTOProtocol>(dto: T, access: Access) -> Single<T> 
    func read<T: DTOProtocol>(type: T.Type, access: Access) -> Observable<T>
}

class FireBaseNetworkService: FireBaseNetworkServiceProtocol {
    var db: Firestore
    var auth: Auth
    private(set) var uid: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    
    init() {
        self.db = Firestore.firestore()
        self.auth = Auth.auth()
        self.uid.accept(auth.currentUser?.uid)
    }
    
}

extension FireBaseNetworkService {
    func signIn(credential: AuthCredential) -> Single<Bool> {
        return Single<Bool>.create {[weak self] single in
            
            self?.auth.signIn(with: credential) {[weak self] result, error in
                if let error = error {
                    print(error.localizedDescription)
                    single(.failure(error))
                    print("net signIn error")
                }
                
                guard let uid = result?.user.uid else { return }
                self?.uid.accept(uid)
//                print("signIn uid: \(self?.uid.value)")
                single(.success(true))
//                print("net signIn seccess")
//               At this point, our user is signed in
            }
            
            return Disposables.create()
        }
        
    }
    
    func signOut() -> Single<Bool> {
        return Single<Bool>.create { single in
            do {
                try self.auth.signOut()
                self.uid.accept(nil)
                single(.success(true))
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
                single(.failure(signOutError))
            }
            
            return Disposables.create()
        }
        
    }
    
    func signUp() -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            do {
                guard let self = self, let uid = self.auth.currentUser?.uid else { throw NetworkServiceError.noNetworkService}
                let ref = try self.documentReference()
                let userDTO = UserDTO(id: uid)
                try ref.setData(from: userDTO)
                self.uid.accept(uid)
                single(.success(true))
//                print("net signUp")
            } catch let error {
                single(.failure(error))
//                print("net signUp error")
            }
            
            return Disposables.create()
        }
        
    }
    
    func checkUserRegistered() -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            do {
                guard let self = self,
                        let uid = self.auth.currentUser?.uid
                      
                else { throw NetworkServiceError.noNetworkService}
//                print("net checkUser do")
                
                self.db.collection(Access.user.path).document(uid).getDocument { snapshot, error in
                    if let error = error {
//                        print("get docu : \(error)")
                        single(.failure(error))
//                        print("net checkUser error")
                    }
                    if let snapshot = snapshot, snapshot.exists {
                                       single(.success(true))
//                                       print("net checkUser success")
                                   } else {
                                       single(.success(false))
//                                       print("net checkUser failure")
                                   }
                }
                
            } catch let error {
                single(.failure(error))
//                print("net checkUser error")
            }

            return Disposables.create()
        }
    }
    
}

extension FireBaseNetworkService {
    private func documentReference() throws -> DocumentReference {
        guard let currentUserUid = self.uid.value else { throw NetworkServiceError.noAuthError }
        
        return self.db.collection(Access.user.path).document(currentUserUid)
    }
    
    func create<T: DTOProtocol>(dto: T, access: Access) -> Single<T> {
        return Single<T>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                let ref = try self.documentReference()
                switch access {
                case .user:
                    try ref.setData(from: dto)
                case .gifticon:
                    break
                }
                single(.success(dto))
            } catch let error {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    func read<T: DTOProtocol>(type: T.Type, access: Access) -> Observable<T> {
        return Observable<T>.create { [weak self] obserser in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                let ref = try self.documentReference()
                switch access {
                case .user:
                    ref.getDocument(as: type) { result in
                        switch result {
                        case .success(let user):
                            obserser.onNext(user)
//                            print("onNext \(user)")
//                            print("read user success")
                        case .failure(let error):
                            obserser.onError(error)
//                            print("onError \(error)")
//                            print("read user error")
                        }
                        obserser.onCompleted()
                        
                    }
                case .gifticon:
                    break
                }
                
            } catch let error {
                obserser.onError(error)
            }
            obserser.onCompleted()
            
            return Disposables.create()
        }
    }
}
