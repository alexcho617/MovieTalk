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
    struct Input{
        let postClicked: ControlEvent<Void>
        
        let title: ControlProperty<String>
        let contents: ControlProperty<String>
        
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
            .withLatestFrom(Observable.zip(input.title, input.contents))
            .flatMapLatest {title, content in                
                let requestmodel = ContentsCreateRequestDTO(title: title, content: content, file: input.postImageData, product_id: "mtSNS", content1: input.movieID, content2: input.movieTitle, content3: nil, content4: nil, content5: nil)
                return ContentsManager.shared.post(requestmodel)
            }
            .bind { result in
                postResult.accept(result)
            }
            .disposed(by: disposeBag)
        
        

        return Output(postResult: postResult)
    }
}

