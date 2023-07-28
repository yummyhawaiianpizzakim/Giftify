//
//  AddGiftiTextView.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/28.
//

import Foundation
import SnapKit
import UIKit

class AddGiftiTextView: UIView {
    
    
    lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쿠폰 이름"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.text = "브랜드"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    lazy var barCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "바코드"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    lazy var expiredDateLabel: UILabel = {
        let label = UILabel()
        label.text = "만료 기한"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "쿠폰 이름"
        return textField
    }()
    
    lazy var brandTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "브랜드 이름"
        return textField
    }()
    
    lazy var barCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "바코드 번호"
        return textField
    }()
    
    lazy var expiredDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "만료 기한"
        return textField
    }()
    
    lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .gray
//        textView.layer.borderColor = UIColor.themeGray300?.cgColor
//        textView.layer.borderWidth = FrameResource.commonBorderWidth
//        textView.layer.cornerRadius = FrameResource.commonCornerRadius
        textView.font = .systemFont(ofSize: 20)
        textView.text = "메모를 남겨주세요"
        textView.textColor = .gray
        textView.textContainerInset = UIEdgeInsets(
            top: 15,
            left: 15,
            bottom: 15,
            right: 15
        )
        
        return textView
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

private extension AddGiftiTextView {
    func configureUI() {
        self.addSubview(self.inputStackView)
        [self.titleLabel, self.titleTextField, self.brandLabel,
         self.brandTextField, self.barCodeLabel, self.barCodeTextField,
         self.expiredDateLabel, self.expiredDateTextField, self.memoLabel,
         self.memoTextView].forEach { view in
            self.inputStackView.addArrangedSubview(view)
        }
        self.inputStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        self.titleTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.brandTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.barCodeTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.expiredDateTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.memoTextView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        [self.titleLabel, self.brandLabel, self.barCodeLabel, self.expiredDateLabel, self.memoLabel].forEach { label in self.inputStackView.setCustomSpacing(20, after: label) }
        
        [self.titleTextField, self.brandTextField, self.barCodeTextField, self.expiredDateTextField, self.memoTextView].forEach { view in self.inputStackView.setCustomSpacing(8, after: view) }
    }
    
    func bindUI() {
        
    }
}
