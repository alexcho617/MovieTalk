//
//  SignUpViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModel{
    var disposeBag = DisposeBag()
    private let status = PublishSubject<AuthState>()

    struct Input{
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output{
        let authStatus: PublishSubject<AuthState>
    }
    
    func transform(input: Input) -> Output {
        
        input.signUpButtonClicked
            .withLatestFrom(Observable.zip(input.email, input.password))
            .flatMapLatest { email, password in
                print("SignUp with", email, password)
                let dto = SignUpRequestDTO(email: email, password: password, nick: "mynick", phoneNum: nil, birthDay: nil)
                return AuthManager.shared.signUp(user: dto)
            }
            .subscribe(
                onNext: { authState in
                    self.status.onNext(authState)
                },
                onError: { error in
                    self.status.onError(error)
                }
            )
            .disposed(by: disposeBag)
        
        return Output(authStatus: status)
    }
    
    
    
}
