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
    var isLoading = false
    
    var nextCursor = "0"
    
    let snsContents = PublishRelay<[Post]>()
    var tempContents: [Post] = []
    struct Input{
    }
    
    struct Output{
        let contents: PublishRelay<[Post]>
    }
    
    func transform(input: Input) -> Output {
        isLoading = true
        ContentsManager.shared.fetch(nextCursor: nextCursor)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, responseDTO in
                owner.tempContents.append(contentsOf: responseDTO.data)
                owner.nextCursor = responseDTO.next_cursor ?? "0"
                owner.snsContents.accept(owner.tempContents)
                owner.isLoading = false

            }
            .disposed(by: disposeBag)
        return Output(contents: snsContents)
    }
    
    func fetch(){
        guard isLoading == false else {return}
        isLoading = true
        ContentsManager.shared.fetch(nextCursor: nextCursor)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, responseDTO in
                owner.tempContents.append(contentsOf: responseDTO.data)
                owner.nextCursor = responseDTO.next_cursor ?? "0"
                owner.snsContents.accept(owner.tempContents)
                owner.isLoading = false
            }
            .disposed(by: disposeBag)
    }
}
