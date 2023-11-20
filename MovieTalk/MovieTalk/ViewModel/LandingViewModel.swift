//
//  LandingViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class LandingViewModel{
    var disposeBag = DisposeBag()
    var authState = PublishSubject<AuthState>()
    init(){
        checkState()
    }
    
    
    func checkState(){
        print(#function)
        //1 get token from userdefautls
        
        //2 check token validation
        AuthManager.shared.refresh()
//            .subscribe(with: self) { owner, state in
////                owner.authState.onNext(state)
//            }
//            .disposed(by: disposeBag)

        //2-1 token is valid
        //go to Home
        
        //2-2 token is invalid
        //3 try refresh
        //3-1 refresh worked
        //4validate new token
        //go to home
        //3-2 refresh didnt work
        //go to login
    }
    
}
