//
//  UserDefaultsManager.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import Foundation

final class UserDefaultsManager{
    
    enum Key: String{
        case token = "token"
        case refresh = "refresh"
        case id = "id"
        case email = "email"
        case nick = "nick"
        
    }
    
    static let shared = UserDefaultsManager()
    let standard = UserDefaults.standard
    private init (){}
    
    var currentToken: String{
        return standard.string(forKey: Key.token.rawValue) ?? ""
    }
    
    var currentRefreshToken: String{
        return standard.string(forKey: Key.refresh.rawValue) ?? ""
    }
    //사용자 정보 저장
    func saveAccountInfo(model: SignUpResponseDTO){
        standard.setValue(model._id, forKey: Key.id.rawValue)
        standard.setValue(model.email, forKey: Key.email.rawValue)
        standard.setValue(model.nick, forKey: Key.nick.rawValue)
    }
    
    //로그인 토큰 저장
    func saveLoginCredentional(model: LoginResponseDTO){
        standard.setValue(model.token, forKey: Key.token.rawValue)
        standard.setValue(model.refreshToken, forKey: Key.refresh.rawValue)
    }
    
}

