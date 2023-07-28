//
//  AddGifticonViewModel.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
import RxSwift
import RxRelay


typealias AddGifticonDataSource = [AddGificonSection: [AddGificonSection.Item]]

class AddGifticonViewModel {
    let mlKit = MLKit()
    let disposeBag = DisposeBag()
    
    let imageData = BehaviorRelay<[AddGifticonViewController.Cell]>(value: [.addButton])
    
    let tapImage = BehaviorRelay<Int>(value: 0)
    
    struct Input {
//        let didTapAddButton: Observable<Void>
//        let pickedImages: Observable<[UIImage]>
        var tapImage = PublishSubject<Int>()

        let imageData = BehaviorRelay<[AddGifticonViewController.Cell]>(value: [.addButton])
    }
    
    struct Output {
        let dataSources = BehaviorRelay<[AddGifticonDataSource]>(value: [])
    }
    
//    func setActions(actions: HomeViewModelActions) {
//        self.actions = actions
//    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
//        input.didTapAddButton
//            .subscribe {[weak self] _ in
//                print("tap!")
//                self?.mlKit.reconizeTextKorean()
//            }
//            .disposed(by: self.disposeBag)
//
//        self.mlKit.text
//            .subscribe { strings in
//                print(strings)
//            }
//            .disposed(by: self.disposeBag)
        
        
        
        return output
    }
}

private extension AddGifticonViewModel {
    func mappingDataSource(images: [GifticonImage]) -> [AddGifticonDataSource] {
        return [mappingDDayDataSurce(images: images)]
    }
    
    func updateGifticonState(images: [GifticonImage]) -> [GifticonImage] {
        return images.map { image in
            return GifticonImage(
                id: image.id,
                url: image.url,
                selectedOrder: image.selectedOrder,
                createdDate: image.createdDate
            )
        }
    }
    
//    func mappingProfileDataSource(user: User) -> UserDataSource {
//        return [UserSection.profile: [UserSection.Item.profile(user)]]
//    }
    
    func mappingDDayDataSurce(images: [GifticonImage]) -> AddGifticonDataSource {
        if images.isEmpty {
            return [AddGificonSection.gifticonImage: []]
        }
        return [AddGificonSection.gifticonImage: updateGifticonState(images: images).map( { AddGificonSection.Item.gificonImage($0) } )]
    }
}

extension AddGifticonViewModel {
    func addImage(orderedData: [Data]) {
        var imageValues = self.imageData.value
        
        if imageValues.count > 10 {
            return
        }
        
//        orderedData.forEach { data in
//            if !imageValues.compactMap({ $0.data }).contains(data) {
//                imageValues.insert(contentsOf: [.image(data: data)], at: imageValues.count - 1)
//                self.imageData.accept(imageValues)
//            }
//        }
        
        orderedData.forEach { data in
            if !imageValues.compactMap({ $0.data }).contains(data) {
                imageValues.append(contentsOf: [.image(data: data)])
                self.imageData.accept(imageValues)
            }
        }
    }
    
}
