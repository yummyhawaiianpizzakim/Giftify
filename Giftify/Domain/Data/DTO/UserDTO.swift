//
//  UserDTO.swift
//  Giftify
//
//  Created by 김요한 on 2023/08/01.
//

import Foundation

struct UserDTO: DTOProtocol {
    var id: String
    
    func toDomain() -> User {
        return User(id: self.id)
    }
}

