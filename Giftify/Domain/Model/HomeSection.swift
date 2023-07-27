//
//  MainSection.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation

enum HomeSection: Int, Hashable {
    
    case near
    case dDay
    
    enum Item: Hashable {
        case near(Gifticon)
        case dDay(Gifticon)
    }
}
