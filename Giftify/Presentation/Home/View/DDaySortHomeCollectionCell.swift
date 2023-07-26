//
//  DDaySortCollectionCell.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import SnapKit
import UIKit

class DDaySortHomeCollectionCell: UICollectionViewCell {
    static var id: String {
        return "DDaySortHomeCollectionCell"
    }
    
    lazy var brandNameLabel: UILabel = {
        let label = UILabel()
        label.text = "brandName"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .gray
        return label
    }()
    
    lazy var gifticonNameLabel: UILabel = {
        let label = UILabel()
        label.text = "gifticon"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DDaySortHomeCollectionCell {
    func configureUI() {
        self.contentView.addSubview(self.brandNameLabel)
        self.brandNameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.contentView.addSubview(self.gifticonNameLabel)
        self.gifticonNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.brandNameLabel.snp.bottom)
            make.left.equalTo(self.brandNameLabel.snp.left)
        }
        
    }
}

extension DDaySortHomeCollectionCell {
    func configureCell(item: Gifticon) {
        
    }
}
