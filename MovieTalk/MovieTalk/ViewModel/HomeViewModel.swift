//
//  HomeViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel{
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let logoutClicked: ControlEvent<Void>
        let withdrawClicked: ControlEvent<Void>
        let refreshClicked: ControlEvent<Void>
        let contentsClicked: ControlEvent<Void>
    }
    
    struct Output {
        let contents: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        //TODO: Implement contents function
        let contents = Observable.just("Initial Value").asDriver(onErrorJustReturn: "nil")
        
        input.withdrawClicked
            .map{
                //비밀번호는 어떻게 할 것인가?? 사용자 에게서 입력?
                let dto = WithdrawRequestDTO(email: UserDefaultsManager.shared.currentEmail, password: "")
            }
        
        
        return Output(contents: contents)
    }
}
