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

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    private let disposeBag = DisposeBag()
    
    func signUp(user: SignUpRequestDTO) -> BehaviorSubject<Result<SignUpResponseDTO, Error>> {
        let resultSubject = BehaviorSubject<Result<SignUpResponseDTO, Error>>(value: .success(SignUpResponseDTO(_id: "", email: "", nick: ""))) // You might want to set an initial value based on your needs
        
        let provider = MoyaProvider<ServerAPI>()
        
        provider.rx
            .request(ServerAPI.signUp(model: user))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .subscribe(
                onNext: { response in
                    if let decodedValue = try? JSONDecoder().decode(SignUpResponseDTO.self, from: response.data) {
                        print("Success", response.statusCode, decodedValue)
                        resultSubject.onNext(.success(decodedValue))
                    }
                },
                onError: { error in
                    if let moyaError = error as? MoyaError, case let .statusCode(response) = moyaError {
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
                            print("Unsuccessful", response.statusCode, errorResponse.message)
                            resultSubject.onNext(.failure(ServerAPIError.apiError(message: errorResponse.message)))
                        }
                    } else {
                        resultSubject.onNext(.failure(error))
                    }
                }
            )
            .disposed(by: disposeBag)
        return resultSubject
    }
}

