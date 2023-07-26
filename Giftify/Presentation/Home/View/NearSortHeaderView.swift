//
//  NearSortHeaderView.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class NearSortHeaderView: UICollectionReusableView {
    static var id: String {
        return "NearSortHeaderView"
    }
    
    lazy var nearSortTitle: UILabel = {
        let label = UILabel()
        label.text = "가까운 장소 기준"
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
        self.backgroundColor = .blue
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NearSortHeaderView {
    func configureUI() {
        self.addSubview(self.nearSortTitle)
        self.nearSortTitle.snp.makeConstraints { make in
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
