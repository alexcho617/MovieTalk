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

    struct Input{
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let nickname: ControlProperty<String>
        let validateEmailButtonClicked: ControlEvent<Void>
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output{
        let authStatus: Driver<Bool>
        let isValidated: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let status = BehaviorSubject(value: false)
        let isValid = BehaviorSubject(value: false)
        
        input.email
                .map { _ in false }
                .asDriver(onErrorJustReturn: false)
                .drive(isValid)
                .disposed(by: disposeBag)
        
        input.validateEmailButtonClicked
            .withLatestFrom(input.email)
            .flatMapLatest{email in
                let dto = ValidateEmailRequestDTO(email: email)
                return AuthManager.shared.validateEmail(email: dto)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(isValid)
            .disposed(by: disposeBag)
        
        input.signUpButtonClicked
            .withLatestFrom(Observable.combineLatest(input.email, input.password, input.nickname))
            .flatMap { email, password, nickname in
                print("SignUp with", email, password, nickname)
                let dto = SignUpRequestDTO(email: email, password: password, nick: nickname, phoneNum: nil, birthDay: nil)
                return AuthManager.shared.signUp(user: dto)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(status)
            .disposed(by: disposeBag)
        
        let output = Output(authStatus: status.asDriver(onErrorJustReturn: false), isValidated: isValid.asDriver(onErrorJustReturn: false))
        return output
    }
    
}
