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
        
    }
    
    struct Output{
        let contents: PublishRelay<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let snsContents = PublishRelay<[Post]>()
//        let networkFailResponseDTO = ContentsReadResponseDTO(data: [], next_cursor: "0")
        ContentsManager.shared.fetch()
            .subscribe(with: self) { owner, responseDTO in
                snsContents.accept(responseDTO.data)
            }
            .disposed(by: disposeBag)
        return Output(contents: snsContents)
    }
}
