//
//  ServerAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import Foundation
import Moya

//TODO: validateEmail, tokenrefresh, withdraw
enum ServerAPI{
    case signUp(model: SignUpRequestDTO)
    case login(model: LoginRequestDTO)
}

enum ServerAPIError: Error {
    case apiError(message: String)
    case unknownError
}

extension ServerAPI: TargetType{
    var baseURL: URL {
        Endpoints.baseURL
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "join"
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let model):
            return .requestJSONEncodable(model)
        case .login(let model):
            return .requestJSONEncodable(model)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .login:
            return [
                "Content-Type" : "application/json",
                "SesacKey" : Secret.key
            ]
        }
        
    }
}
