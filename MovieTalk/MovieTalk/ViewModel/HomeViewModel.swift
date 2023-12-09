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
    let isRefreshing = PublishRelay<Bool>()

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
    
    func fetch(isRefreshing: Bool = false, completion: @escaping (() -> Void)){
//        과호출 방어
        if isRefreshing{
            tempContents = []
            nextCursor = "" //밑에 가드문 우회
        }
        //현재 로딩상태와 다음 데이터 존재유무 확인
        guard isLoading == false, nextCursor != "0" else { return }

        isLoading = true
        ContentsManager.shared.fetch(nextCursor: nextCursor)
            .debounce(.seconds(1), scheduler: MainScheduler.instance) //과호출 방어
            .subscribe(with: self) { owner, responseDTO in
                owner.tempContents.append(contentsOf: responseDTO.data)
                owner.nextCursor = responseDTO.next_cursor ?? "0"
                owner.snsContents.accept(owner.tempContents)
                owner.isLoading = false
            }
            .disposed(by: disposeBag)
        completion()
    }
    
    func updateComment(forPostID postID: String, with newComments: [Comment]){
        guard let index = tempContents.firstIndex(where: { $0.id == postID }) else {//해당 연산도 비용이 높긴함
//            print(#function,"index error")
            return
        }
        
        let currentComments = tempContents[index].comments ?? []
        
        guard currentComments != newComments else {
//            print(#function,"No change in comment")
            return
        }
        
//        print("Change in Comment, updating")
        tempContents[index].comments = newComments
        snsContents.accept(tempContents)
    }
}
