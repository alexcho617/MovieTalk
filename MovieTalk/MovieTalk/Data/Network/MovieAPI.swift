//
//  MovieAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import Foundation
import Moya

enum MovieAPI{
    case lookUp(id: String)
    case search(query: String)
}

extension MovieAPI: TargetType{
    var baseURL: URL {
        Secret.tmdbBaseURL
    }
    
    var path: String {
        switch self {
        case .lookUp(let id):
            return "movie/\(id)"
        case .search:
            return "movie"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .lookUp:
            let parameters = [
                "api_key" : Secret.tmdbKey,
                "language" : "ko-KR"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .search(let query):
            let parameters = [
                "api_key" : Secret.tmdbKey,
                "query" : query,
                "language" : "ko-KR"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        nil
    }
    
    
}
