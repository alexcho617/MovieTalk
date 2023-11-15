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
    case loggedOut
    case fail
    case none
}

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    private let disposeBag = DisposeBag()
    
    //SSOT
    var currentAuthState = PublishSubject<AuthState>()
    
    func signUp(user: SignUpRequestDTO) -> PublishSubject<AuthState>{
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
                        print("ServerResponse",responseDTO)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        return currentAuthState
    }
    
    func validateEmail(email: ValidateEmailRequestDTO) -> PublishSubject<Bool>{
        let validationResult = PublishSubject<Bool>()

        let provider = MoyaProvider<ServerAPI>()
        provider.rx
            .request(ServerAPI.validateEmail(model: email))
            .asObservable()
            .subscribe(with: self) { owner, response in
                if response.statusCode == 200{
                    if let responseDTO = try? JSONDecoder().decode(ValidateEmailResponseDTO.self, from: response.data){
                        print("ServerResponse",responseDTO)
                        validationResult.onNext(true)
                    }
                }else{
                    if let responseDTO = try? JSONDecoder().decode(ValidateEmailResponseDTO.self, from: response.data){
                        print("ServerResponse",responseDTO)
                        validationResult.onNext(false)
                    }
                }
            }.disposed(by: disposeBag)
        return validationResult
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
        print("ServerResponse",errorDTO.message, "\(errorDTO.code ?? -999)")
    }else{
        print("Error Decoding Failed")
    }
}
