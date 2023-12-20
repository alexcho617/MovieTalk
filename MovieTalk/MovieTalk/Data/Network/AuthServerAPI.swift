//
//  ServerAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import Foundation
import Moya


enum AuthServerAPI{
    case signUp(model: SignUpRequestDTO)
    case login(model: LoginRequestDTO)
    case validateEmail(model: ValidateEmailRequestDTO)
    case refresh
    case withdraw
}

extension AuthServerAPI: TargetType{
    var baseURL: URL {
        Secret.baseURL
    }
    
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
        case .signUp, .login, .validateEmail:
            return .post
        case .refresh, .withdraw:
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
        case .refresh, .withdraw:
            return .requestPlain
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
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "SesacKey" : Secret.key
            ]
        case .refresh:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "Refresh" : UserDefaultsManager.shared.currentRefreshToken,
                "SesacKey" : Secret.key
            ]
        }
        
    }
}
