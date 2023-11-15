//
//  ServerAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import Foundation
import Moya


enum ServerAPI{
    case signUp(model: SignUpRequestDTO)
    case login(model: LoginRequestDTO)
    case validateEmail(model: ValidateEmailRequestDTO)
    case refresh
    case withdraw(model:WithdrawRequestDTO)
    
}              

enum ServerAPIError: Error {
    case apiError(message: String)
    case unknownError
}

extension ServerAPI: TargetType{
    var baseURL: URL {
        Endpoints.baseURL
    }
    //TODO: endpoint enum.rawvalue로 개선 가능
    var path: String {
        switch self {
        case .signUp:
            return "join"
        case .login:
            return "login"
        case .validateEmail:
            return "validation/email"
        case .refresh:
            return "refresh"
        case .withdraw:
            return "withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login, .validateEmail, .withdraw:
            return .post
        case .refresh:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let model):
            return .requestJSONEncodable(model)
            
        case .login(let model):
            return .requestJSONEncodable(model)
            
        case .validateEmail(model: let model):
            return .requestJSONEncodable(model)
        case .refresh:
            return .requestPlain
        case .withdraw(model: let model):
            return .requestJSONEncodable(model)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .login, .validateEmail:
            return [
                "Content-Type" : "application/json",
                "SesacKey" : Secret.key
            ]
        case .withdraw:
            return [
                "Content-Type" : "application/json",
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "SesacKey" : Secret.key
            ]
        //TODO: refresh test, UD의 타이밍 이슈로인해 불러오지못할 수 있음
        case .refresh:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "Refresh" : UserDefaultsManager.shared.currentRefreshToken,
                "SesacKey" : Secret.key
            ]
        }
        
    }
}
