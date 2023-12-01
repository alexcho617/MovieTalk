//
//  UserDefaultsManager.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import Foundation

final class UserDefaultsManager{
    
    enum Key: String, CaseIterable{
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
        get{
            return standard.string(forKey: Key.token.rawValue) ?? ""
        }
        set{
            standard.set(newValue, forKey: Key.token.rawValue)
        }
    }
    
    var currentRefreshToken: String{
        get{
            return standard.string(forKey: Key.refresh.rawValue) ?? ""
        }
        set{
            standard.set(newValue, forKey: Key.refresh.rawValue)
        }
        
    }
    
    var currentEmail: String{
        get{
            return standard.string(forKey: Key.email.rawValue) ?? ""
        }
        set{
            standard.set(newValue, forKey: Key.email.rawValue)
        }
    }
    
    var currentUserID: String{
        get{
            return standard.string(forKey: Key.id.rawValue) ?? ""
        }
        set{
            standard.set(newValue, forKey: Key.id.rawValue)
        }
    }
    
    
    //사용자 정보 저장
    func saveAccountInfo(model: SignUpResponseDTO){
        standard.setValue(model._id, forKey: Key.id.rawValue)
        standard.setValue(model.email, forKey: Key.email.rawValue)
        standard.setValue(model.nick, forKey: Key.nick.rawValue)
    }
    
    func saveToken(model: RefreshTokenResponseDTO){
        standard.setValue(model.token, forKey: Key.token.rawValue)
    }
    //로그인 토큰 저장
    func saveLoginCredentional(model: LoginResponseDTO){
        standard.setValue(model.token, forKey: Key.token.rawValue)
        standard.setValue(model.refreshToken, forKey: Key.refresh.rawValue)
        standard.setValue(model._id, forKey: Key.id.rawValue)

    }
    
    func printAllData(){
        print("===PRINTING UD...===")
        let keys = Key.allCases
        for key in keys {
            print(key.rawValue,standard.object(forKey: key.rawValue) ?? "nil")
        }
        print("===END OF UD...===")

    }
    
    func clearToken(){
//        printAllData()
        standard.removeObject(forKey: Key.token.rawValue)
        standard.removeObject(forKey: Key.refresh.rawValue)
        print("TOKENS CLEARED FROM UD")
//        printAllData()
    }
}

