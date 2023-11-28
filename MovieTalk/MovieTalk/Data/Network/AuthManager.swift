//
//  AuthManager.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation
import RxMoya
import Moya
import RxSwift

enum AuthState{
    case loggedIn
    case loggedOut
}

// API Call(1) -> 419 -> refresh -> 갱신 -> API Call(1) : interceptor

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    private let disposeBag = DisposeBag()
    
    //TODO: AuthRefactor - Singleton 으로 상태관리를 하고 있어서 dispose가 제대로 안되고 있으며 여러모로 이벤트 관리가 안되고 있음. 컨텐츠 쪽만 격리 시켜서 관리하고 현재 refresh에서 이벤트 중복 발생하는건 인지하고 넘어가자.
    var currentAuthState = PublishSubject<AuthState>()
    
    func signUp(user: SignUpRequestDTO) -> BehaviorSubject<Bool>{
        print("AuthManager:", #function)
        let signUpResult = BehaviorSubject(value: false)
        let recovery = PublishSubject<Response>() //catch block
        let provider = MoyaProvider<AuthServerAPI>()//(session: Moya.Session(interceptor: Interceptor()))
        provider.rx
            .request(AuthServerAPI.signUp(model: user))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .catch{ error in
                handleStatusCodeError(error)
                return recovery
            }
            .subscribe(with: self, onNext: { owner, response in
                if response.statusCode == 200{
                    if let responseDTO = try? JSONDecoder().decode(SignUpResponseDTO.self, from: response.data) {
                        UserDefaultsManager.shared.saveAccountInfo(model: responseDTO)
                        owner.currentAuthState.onNext(.loggedOut)
                        print("Server: Registration Success",responseDTO)
                        signUpResult.onNext(true)
                    }
                }else{
                    signUpResult.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return signUpResult
    }
    
    func validateEmail(email: ValidateEmailRequestDTO) -> PublishSubject<Bool>{
        print("AuthManager:", #function)
        let validationResult = PublishSubject<Bool>()
        
        let provider = MoyaProvider<AuthServerAPI>()
        provider.rx
            .request(AuthServerAPI.validateEmail(model: email))
            .asObservable()
            .subscribe(with: self) { owner, response in
                if response.statusCode == 200{
                    if let responseDTO = try? JSONDecoder().decode(ValidateEmailResponseDTO.self, from: response.data){
                        print("Server: Valid Email",responseDTO)
                        validationResult.onNext(true)
                    }
                }else{
                    if let responseDTO = try? JSONDecoder().decode(ValidateEmailResponseDTO.self, from: response.data){
                        print("Server: Invalid Email ",responseDTO)
                        validationResult.onNext(false) //실패해도 에러 이벤트를 반환하지 않고 onNext에 false를 전달함
                    }
                }
            }.disposed(by: disposeBag)
        return validationResult
    }
    
    func login(model: LoginRequestDTO) -> PublishSubject<AuthState>{
        print("AuthManager:", #function)
        let recovery = PublishSubject<Response>()
        let provider = MoyaProvider<AuthServerAPI>()
        
        provider.rx.request(AuthServerAPI.login(model: model))
            .asObservable()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .catch { error in
                handleStatusCodeError(error)
                return recovery
            }
            .subscribe(with: self) { owner, response in
                if response.statusCode == 200{
                    if let responseDTO = try? JSONDecoder().decode(LoginResponseDTO.self, from: response.data){
                        UserDefaultsManager.shared.saveLoginCredentional(model: responseDTO)
                        owner.currentAuthState.onNext(.loggedIn)
                        print("Server: Login Success", responseDTO)
                    }
                }
            }
            .disposed(by: disposeBag)
        return currentAuthState
    }
    
    func withdraw() -> PublishSubject<AuthState>{
        print("AuthManager::", #function)
        let provider = MoyaProvider<AuthServerAPI>()
        let recovery = PublishSubject<Response>()
        provider.rx.request(AuthServerAPI.withdraw)
            .asObservable()
            .filterSuccessfulStatusCodes()
            .catch { error in
                handleStatusCodeError(error)
                return recovery
            }
            .subscribe(with: self) { owner, response in
                if response.statusCode == 200{
                    if let responseDTO = try? JSONDecoder().decode(WithdrawResponseDTO.self, from: response.data){
                        owner.currentAuthState.onNext(.loggedOut)
                        print("Server: Account Withdrawn")
                        print(responseDTO)
                    }
                }
                else if response.statusCode == 419{
                    print("Need AccessToken Refresh", response.statusCode)
                }
            }.disposed(by: disposeBag)
        return currentAuthState
    }
    
    func refresh() -> PublishSubject<AuthState>{
        print("AuthManager::", #function)
        let provider = MoyaProvider<AuthServerAPI>()
        let recovery = PublishSubject<Response>()
        
        provider.rx.request(AuthServerAPI.refresh)
            .asObservable()
            .catch { error in
                handleStatusCodeError(error)
                return recovery
            }
            .subscribe(with: self) { owner, response in
                switch response.statusCode{
                case 200:
                    if let responseDTO = try? JSONDecoder().decode(RefreshTokenResponseDTO.self, from: response.data){
                        print("Server: Token Refreshed",responseDTO)
                        //save current token
                        UserDefaultsManager.shared.saveToken(model: responseDTO)
                        owner.currentAuthState.onNext(.loggedIn)
                    }
                case 403:
                    print("Server: Forbidden")
                    owner.currentAuthState.onNext(.loggedOut)
                case 409:
                    print("Server: Token Not Outdated", response)
                    owner.currentAuthState.onNext(.loggedIn)
                case 418:
                    print("Server: Token Outdated, Re Log In", response)
                    owner.currentAuthState.onNext(.loggedOut)
                    print("Need to login")
                default:
                    print("Server: Refresh Failed", response)
                    owner.currentAuthState.onNext(.loggedOut)
                    print("Need to login")
                }
            }
            .disposed(by: disposeBag)
        return currentAuthState
    }
    
    deinit {
        print("AuthManager deinit")
    }
}


public func handleStatusCodeError(_ error: Error) {
    guard let moyaError = error as? MoyaError else {return}
    guard let response = moyaError.response else {return}
    if var errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
        errorDTO.code = response.statusCode
        print("Server: Fail",errorDTO.message, "\(errorDTO.code ?? -999)")
    }else{
        print("Server: Unknown Error")
    }
}
