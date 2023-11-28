//
//  HomeViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel{
    var disposeBag = DisposeBag()
    struct Input{
//        let moreClicked: ControlEvent<Void>
    }
    
    struct Output{
        let contents: PublishRelay<[Post]>
//        let cellExpanded: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        var isExpand = false
        let snsContents = PublishRelay<[Post]>()
//        let cellExpanded = BehaviorRelay(value: false)

        ContentsManager.shared.fetch()
            .subscribe(with: self) { owner, responseDTO in
                snsContents.accept(responseDTO.data)
            }
            .disposed(by: disposeBag)
//        
//        input.moreClicked
//            .bind { _ in
//                isExpand.toggle()
//                cellExpanded.accept(isExpand)
//            }
//            .disposed(by: disposeBag)
        
        return Output(contents: snsContents)
    }
}
