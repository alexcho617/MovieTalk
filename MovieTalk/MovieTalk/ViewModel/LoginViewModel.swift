//
//  LoginViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModel{
    var disposeBag = DisposeBag()
    private let status = PublishSubject<AuthState>()
    private let validated = BehaviorSubject(value: false)
    
    struct Input{
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let loginClicked: ControlEvent<Void>
    }
    
    struct Output{
        let authStatus: Driver<AuthState>
        let isValidated: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        disposeBag = DisposeBag()
        //validate
        Observable.combineLatest(input.email, input.password) { email, password in
            if email.isEmpty || email.count < 4 || password.isEmpty{
                return false
            }else{
                return true
            }
        }
        .asDriver(onErrorJustReturn: false)
        .drive(validated)
        .disposed(by: disposeBag)
        
        
        //login request
        input.loginClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
        //MARK: FlatMap -> FlatMapLatest로 변경하여 해결
            .flatMapLatest{email, password in
                print("Login with", email, password)
                let dto = LoginRequestDTO(email: email, password: password)
                return AuthManager.shared.login(model: dto)
            }
            .subscribe(with: self, onNext: { owner, result in
                owner.status.onNext(result)
            })
            .disposed(by: disposeBag)
        
        let output = Output(authStatus: status.asDriver(onErrorJustReturn: .loggedOut), isValidated: validated.asDriver(onErrorJustReturn: false))
        return output
    }
    
}
