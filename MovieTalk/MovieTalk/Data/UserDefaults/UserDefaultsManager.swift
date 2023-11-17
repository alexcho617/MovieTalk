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
        return standard.string(forKey: Key.token.rawValue) ?? ""
    }
    
    var currentRefreshToken: String{
        return standard.string(forKey: Key.refresh.rawValue) ?? ""
    }
    
    var currentEmail: String{
        return standard.string(forKey: Key.email.rawValue) ?? ""
    }
    
    //TODO: 비밀번호는 없음. 그렇다면 withdraw는 어떻게 할 것인가? 사용자에게 받아야함
    
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
    func printAllData(){
        print("===PRINTING UD...===")
        let keys = Key.allCases
        for key in keys {
            print(key.rawValue,standard.object(forKey: key.rawValue) ?? "nil")
        }
        print("===END OF UD...===")

    }
    func clearToken(){
        printAllData()
        standard.removeObject(forKey: Key.token.rawValue)
        standard.removeObject(forKey: Key.refresh.rawValue)
        print("TOKENS CLEARED FROM UD")
        printAllData()
    }
}

