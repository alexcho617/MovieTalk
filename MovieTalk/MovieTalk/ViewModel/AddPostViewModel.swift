//
//  AddPostViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/25/23.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class AddPostViewModel: ViewModel{
    var disposeBag = DisposeBag()
    var titleString = ""
    var contentsString = ""
    struct Input{
        let postClicked: ControlEvent<Void>
        
        let movieID: String
        let movieTitle: String
        let postImageData: Data
    }
    
    struct Output{
        let postResult: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postResult = PublishRelay<Bool>()
        
        input.postClicked
           
            .flatMapLatest {
                let requestmodel = ContentsCreateRequestDTO(title: self.titleString, content: self.contentsString, file: input.postImageData, product_id: "mtSNS", content1: input.movieID, content2: input.movieTitle, content3: nil, content4: nil, content5: nil)
                print("PostModel:",requestmodel) //이 시점에서 이미 짤렸음. 내용이 구독이 안되고 있음
                return ContentsManager.shared.post(requestmodel)
            }
            .bind { result in
                postResult.accept(result)
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult)
    }
}

