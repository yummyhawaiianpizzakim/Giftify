//
//  HomeViewModel.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import RxSwift
import RxRelay

struct HomeViewModelActions {
    let showAddGifticonView: () -> Void
}

typealias HomeDataSource = [HomeSection: [HomeSection.Item]]

class HomeViewModel {
    let disposeBag = DisposeBag()
    
    var actions: HomeViewModelActions?
    
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
        let dataSources = BehaviorRelay<[HomeDataSource]>(value: [])
    }
    
    func setActions(actions: HomeViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didTapAddGifticonButton
            .subscribe { _ in
                self.actions?.showAddGifticonView()
            }
            .disposed(by: self.disposeBag)
        
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
    func mappingDataSource(gifticons: [Gifticon]) -> [HomeDataSource] {
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
    
    func mappingNearDataSurce(gifticons: [Gifticon]) -> HomeDataSource {
        if gifticons.isEmpty {
            return [HomeSection.near: []]
        }
        return [HomeSection.near: updateGifticonState(gifticons: gifticons).map( { HomeSection.Item.near($0) } )]
    }
    
    func mappingDDayDataSurce(gifticons: [Gifticon]) -> HomeDataSource {
        if gifticons.isEmpty {
            return [HomeSection.dDay: []]
        }
        return [HomeSection.dDay: updateGifticonState(gifticons: gifticons).map( { HomeSection.Item.dDay($0) } )]
    }
}
