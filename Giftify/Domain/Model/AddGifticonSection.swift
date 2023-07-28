//
//  AddGifticonSection.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/27.
//

import Foundation

enum AddGificonSection:Int, Hashable {
    case gifticonImage
    
    enum Item: Hashable {
        case addGificonImage
        case gificonImage(GifticonImage)
    }
}
