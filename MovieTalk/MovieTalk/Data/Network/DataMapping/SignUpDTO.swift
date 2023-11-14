//
//  AuthenticationDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation

struct SignUpRequestDTO: Encodable{
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}

struct SignUpResponseDTO: Decodable{
    let _id: String
    let email: String
    let nick: String
}
