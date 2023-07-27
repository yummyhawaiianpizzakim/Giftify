//
//  AddGifticonViewController.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddGifticonViewController: UIViewController {
    var viewModel: AddGifticonViewModel?
    let disposeBag = DisposeBag()
    
    lazy var addbutton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.text = "추가하기"
        button.titleLabel?.textColor = .black
        button.backgroundColor = .red
        button.isEnabled = true
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: AddGifticonViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    // 이름 바코드 브랜드 유효기간
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configureUI()
        self.bind()
    }
}

private extension AddGifticonViewController {
    func configureUI() {
        self.view.addSubview(self.addbutton)
        self.addbutton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    func bind() {
        let input = AddGifticonViewModel.Input(
            didTapAddButton: self.addbutton.rx.tap.asObservable()
        )
        let output = self.viewModel?.transform(input: input)
        
    }
}
