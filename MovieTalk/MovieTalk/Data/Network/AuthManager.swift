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
    case signedUp
    case timedOut
    case loggedOut
    case withdrawn
    case fail
    case none
}

// API Call(1) -> 419 -> refresh -> 갱신 -> API Call(1) : interceptor

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    private let disposeBag = DisposeBag()
    
    //SSOT
    //Publish Subject 리턴하는거 별로 안좋음 Observable()
    var currentAuthState = PublishSubject<AuthState>()
    
    func signUp(user: SignUpRequestDTO) -> PublishSubject<AuthState>{
        print("START:", #function)
        
        let recovery = PublishSubject<Response>() //catch block
        
        let provider = MoyaProvider<ServerAPI>()
        provider.rx
            .request(ServerAPI.signUp(model: user))
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
                        owner.currentAuthState.onNext(.signedUp)
                        print("Server: Registration Success",responseDTO)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        return currentAuthState
    }
    
    func validateEmail(email: ValidateEmailRequestDTO) -> PublishSubject<Bool>{
        print("START:", #function)
        let validationResult = PublishSubject<Bool>()
        
        let provider = MoyaProvider<ServerAPI>()
        provider.rx
            .request(ServerAPI.validateEmail(model: email))
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
                        validationResult.onNext(false)
                    }
                }
            }.disposed(by: disposeBag)
        return validationResult
    }
    
    func login(model: LoginRequestDTO) -> PublishSubject<AuthState>{
        print("START:", #function)
        let recovery = PublishSubject<Response>()
        let provider = MoyaProvider<ServerAPI>()
        
        provider.rx.request(ServerAPI.login(model: model))
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
        print("START:", #function)
        let provider = MoyaProvider<ServerAPI>()
        let recovery = PublishSubject<Response>()
        provider.rx.request(ServerAPI.withdraw)
            .asObservable()
            .filterSuccessfulStatusCodes()
            .catch { error in
                handleStatusCodeError(error)
                return recovery
            }
            .subscribe(with: self) { owner, response in
                if response.statusCode == 200{
                    if let responseDTO = try? JSONDecoder().decode(WithdrawResponseDTO.self, from: response.data){
                        owner.currentAuthState.onNext(.withdrawn)
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
        print("START:", #function)
        let provider = MoyaProvider<ServerAPI>()
        let recovery = PublishSubject<Response>()
        
        provider.rx.request(ServerAPI.refresh)
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
                case 409:
                    print("Server: Token Not Outdated", response)
                    owner.currentAuthState.onNext(.loggedIn)
                case 418:
                    print("Server: Token Outdated, Re Log In", response)
                    owner.currentAuthState.onNext(.timedOut)
                    print("Need to login")
                default:
                    print("Server: Refresh Failed", response)
                    owner.currentAuthState.onNext(.timedOut)
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


func handleStatusCodeError(_ error: Error) {
    guard let moyaError = error as? MoyaError else {return}
    guard let response = moyaError.response else {return}
    if var errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
        errorDTO.code = response.statusCode
        print("Server: Fail",errorDTO.message, "\(errorDTO.code ?? -999)")
    }else{
        print("Server: Unknown Error")
    }
}