//
//  AddGifticonPlaceHolderView.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/27.
//

import Foundation
import UIKit

class AddGifticonPlaceHolderView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension AddGifticonPlaceHolderView {
    func configureUI() {
        self.addSubview(self.addbutton)
        self.addbutton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    func bindUI() {
        
    }
}
