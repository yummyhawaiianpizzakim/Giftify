//
//  AddGifticonCollectionButtonCell.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/27.
//

import Foundation
import SnapKit
import UIKit

class AddGifticonCollectionButtonCell: UICollectionViewCell {
    static var id: String {
        return "AddGifticonCollectionButtonCell"
    }
    
    lazy var addImageView: UIImageView = {
        let imageView = UIImageView()
        let addImage = UIImage(systemName: "plus.square.on.square")
        imageView.image = addImage
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
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

private extension AddGifticonCollectionButtonCell {
    func configureUI() {
//        self.contentView.addSubview(self.addButton)
//        self.addButton.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        self.contentView.addSubview(self.addImageView)
        self.addImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func bindUI() {
        
    }
}

extension AddGifticonCollectionButtonCell {
    func configureCell() {
        
    }
}
