//
//  Gifticon.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation

struct Gifticon: Hashable {
    var id: String
    var createdAt: Date
    var userId: String
    var hasImage: Bool
    var croppedUri: String
    var name: String
    var brand: String
    var expireAt: Date
    var barcode: String
    var isCashCard: Bool
    var balance: Int?
    var memo: String
    var isUsed: Bool
    
    init(id: String, createdAt: Date, userId: String, hasImage: Bool, croppedUri: String, name: String, brand: String, expireAt: Date, barcode: String, isCashCard: Bool, balance: Int?, memo: String, isUsed: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.userId = userId
        self.hasImage = hasImage
        self.croppedUri = croppedUri
        self.name = name
        self.brand = brand
        self.expireAt = expireAt
        self.barcode = barcode
        self.isCashCard = isCashCard
        self.balance = balance
        self.memo = memo
        self.isUsed = isUsed
    }
}

