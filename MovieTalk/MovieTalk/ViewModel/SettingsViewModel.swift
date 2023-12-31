//
//  HomeViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModel{
    
    var disposeBag = DisposeBag()
    private let authStatus = PublishSubject<AuthState>()
    
    struct Input {
        let logoutClicked: ControlEvent<Void>
        let withdrawClicked: ControlEvent<Void>
        let refreshClicked: ControlEvent<Void>
    }
    
    struct Output {
        let authStatus: Driver<AuthState>
    }
    
    func transform(input: Input) -> Output {
        input.logoutClicked
            .asObservable()
            .map{
                return AuthState.loggedOut
            }
            .subscribe(with: self) { owner, state in
                owner.authStatus.onNext(state)
                UserDefaultsManager.shared.clearToken()
            }
            .disposed(by: disposeBag)
        
        input.withdrawClicked
            .flatMapLatest{
                return AuthManager.shared.withdraw()
            }
            .subscribe(with: self) { owner, state in
                owner.authStatus.onNext(state)
            }
            .disposed(by: disposeBag)
        
        input.refreshClicked
            .flatMapLatest {
                return AuthManager.shared.refresh()
            }
            .subscribe(with: self) { owner, state in
                owner.authStatus.onNext(state)
            }
            .disposed(by: disposeBag)
        
        return Output(authStatus: authStatus.asDriver(onErrorJustReturn: .loggedOut))
    }
}
