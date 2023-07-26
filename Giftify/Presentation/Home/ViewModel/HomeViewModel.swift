//
//  HomeViewModel.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import RxSwift
import RxRelay

typealias MainDataSource = [MainSection: [MainSection.Item]]

class HomeViewModel {
    let disposeBag = DisposeBag()
    
    let mockGifticons = BehaviorRelay<[Gifticon]>(value: [Gifticon(
        id: "",
        createdAt: Date(),
        userId: "",
        hasImage: false,
        croppedUri: "",
        name: "tmq",
        brand: "tmqjr",
        expireAt: Date(),
        barcode: "123456",
        isCashCard: false,
        balance: 0,
        memo: "aaa",
        isUsed: false
    )])
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var didTapAddGifticonButton: Observable<Void>
    }
    
    struct Output {
        let dataSources = BehaviorRelay<[MainDataSource]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        self.mockGifticons
            .withUnretained(self)
            .map { owner , gifticons in
                owner.mappingDataSource(gifticons: gifticons)
            }
            .bind(to: output.dataSources)
            .disposed(by: self.disposeBag)
        
        return output
    }
}

private extension HomeViewModel {
    func mappingDataSource(gifticons: [Gifticon]) -> [MainDataSource] {
        return [mappingNearDataSurce(gifticons: gifticons)] + [mappingDDayDataSurce(gifticons: gifticons)]
    }
    
    func updateGifticonState(gifticons: [Gifticon]) -> [Gifticon] {
        return gifticons.map { gifticon in
            return Gifticon(
                id: gifticon.id,
                createdAt: gifticon.createdAt,
                userId: gifticon.userId,
                hasImage: gifticon.hasImage,
                croppedUri: gifticon.croppedUri,
                name: gifticon.name,
                brand: gifticon.brand,
                expireAt: gifticon.expireAt,
                barcode: gifticon.barcode,
                isCashCard: gifticon.isCashCard,
                balance: gifticon.balance,
                memo: gifticon.memo,
                isUsed: gifticon.isUsed
            )
        }
    }
    
//    func mappingProfileDataSource(user: User) -> UserDataSource {
//        return [UserSection.profile: [UserSection.Item.profile(user)]]
//    }
    
    func mappingNearDataSurce(gifticons: [Gifticon]) -> MainDataSource {
        if gifticons.isEmpty {
            return [MainSection.near: []]
        }
        return [MainSection.near: updateGifticonState(gifticons: gifticons).map( { MainSection.Item.near($0) } )]
    }
    
    func mappingDDayDataSurce(gifticons: [Gifticon]) -> MainDataSource {
        if gifticons.isEmpty {
            return [MainSection.dDay: []]
        }
        return [MainSection.dDay: updateGifticonState(gifticons: gifticons).map( { MainSection.Item.dDay($0) } )]
    }
}
