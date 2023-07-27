//
//  AddGifticonViewModel.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
import RxSwift
import RxRelay


class AddGifticonViewModel {
    let mlKit = MLKit()
    let disposeBag = DisposeBag()
    
    struct Input {
        let didTapAddButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
//    func setActions(actions: HomeViewModelActions) {
//        self.actions = actions
//    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.didTapAddButton
            .subscribe {[weak self] _ in
                print("tap!")
                self?.mlKit.reconizeTextKorean()
            }
            .disposed(by: self.disposeBag)
        
        self.mlKit.text
            .subscribe { strings in
                print(strings)
            }
        
        return output
    }
}
