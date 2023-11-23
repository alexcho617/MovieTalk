//
//  MovieAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import Foundation
import Moya

enum MovieAPI{
    case search(id: String)
}

extension MovieAPI: TargetType{
    var baseURL: URL {
        Secret.tmdbBaseURL
    }
    
    var path: String {
        switch self {
        case .search(let id):
            return "movie/\(id)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestParameters(parameters: ["api_key" : Secret.tmdbKey], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        nil
    }
    
    
}
