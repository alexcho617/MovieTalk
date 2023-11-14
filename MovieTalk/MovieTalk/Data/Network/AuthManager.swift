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
    case timeout
}

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    private let disposeBag = DisposeBag()
    
    //    SSOT
    var currentAuthState = PublishSubject<AuthState>()
    
    func signUp(user: SignUpRequestDTO) -> PublishSubject<AuthState>{
        let provider = MoyaProvider<ServerAPI>()
        provider.rx
            .request(ServerAPI.signUp(model: user))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .subscribe(with: self,
                onNext: { owner, response in
                if let decodedResponse = try? JSONDecoder().decode(SignUpResponseDTO.self, from: response.data) {
                    //TODO: abstract to  manager class
                    UserDefaultsManager.shared.saveAccountInfo(model: decodedResponse)
                    owner.currentAuthState.onNext(.signedUp)
                    print("ServerResponse",decodedResponse)
                }
            },
                onError: { owner, error in
                if let moyaError = error as? MoyaError, case let .statusCode(response) = moyaError {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
                        owner.currentAuthState.onError(ServerAPIError.apiError(message: errorResponse.message))
                        print("ServerResponse",errorResponse)

                    }
                }
            })
            .disposed(by: disposeBag)
        return currentAuthState
    }
    
    deinit {
        print("AUthmanager deinit")
    }
}

