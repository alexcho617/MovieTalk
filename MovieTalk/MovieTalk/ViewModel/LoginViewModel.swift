//
//  LoginViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation
import RxSwift

class LoginViewModel{
    let disposeBag = DisposeBag()
    let manager = AuthManager.shared

    func login(){
        print("VM: Signup")

        manager.signUp(user: SignUpRequestDTO(email: "alex@sesac.com", password: "alexpw", nick: "alex", phoneNum: nil, birthDay: nil))
            .disposed(by: disposeBag)
        //TODO: 네비게이션 처리
        //TODO: 로그인 실행
        
        //TODO: Error처리
    }
}
