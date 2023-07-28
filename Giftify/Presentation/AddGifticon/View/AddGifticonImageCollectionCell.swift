//
//  AddGifticonImageCollectionCell.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/27.
//

import Foundation
import SnapKit
import UIKit

class AddGifticonImageCollectionCell: UICollectionViewCell {
    static var id: String {
        return "AddGifticonImageCollectionCell"
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddGifticonImageCollectionCell {
    func configureUI() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func bindUI() {
        
    }
    
    func setImage(data: Data) {
        let image = UIImage(data: data)
        self.imageView.image = image
    }
}

extension AddGifticonImageCollectionCell {
    func configureCell(item: Data) {
        self.setImage(data: item)
    }
}
