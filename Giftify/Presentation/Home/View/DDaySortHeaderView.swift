//
//  DDaySortHeaderView.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class DDaySortHeaderView: UICollectionReusableView {
    static var id: String {
        return "DDaySortHeaderView"
    }
    
    lazy var dDaySortTitle: UILabel = {
        let label = UILabel()
        label.text = "사용 기한 기준"
        label.font = .systemFont(ofSize: 50)
        label.textColor = .black
        return label
    }()
    
    lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "map"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .magenta
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DDaySortHeaderView {
    func configureUI() {
        self.addSubview(self.dDaySortTitle)
        self.dDaySortTitle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        self.nearSortTitle.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(10)
//        }
        self.addSubview(self.mapButton)
        self.mapButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
    }
}
