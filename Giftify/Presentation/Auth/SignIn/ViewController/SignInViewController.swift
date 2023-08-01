//
//  SignInViewController.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/31.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    var viewModel: SignInViewModel?
    let disposeBag = DisposeBag()
    
    lazy var signInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .standard
        button.colorScheme = .light
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(viewModel: SignInViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
        print("signInViewDidLoad")
    }
}

private extension SignInViewController {
    func configureUI() {
        self.view.addSubview(self.signInButton)
        self.signInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    func bindUI() {
//        let input = SignInViewModel.Input(
//        )
//        let output = self.viewModel?.transform(input: input)
        
        self.signInButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.generateGoogleCredential()
            })
            .disposed(by: self.disposeBag)
        
    }
    
    func generateGoogleCredential() {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
              guard error == nil else { return }

              guard let user = result?.user,
                let idToken = user.idToken?.tokenString
              else { return }
                
              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)
                self.viewModel?.signIn(credential: credential)
                print("credential")

            }
        
    }
    
}
