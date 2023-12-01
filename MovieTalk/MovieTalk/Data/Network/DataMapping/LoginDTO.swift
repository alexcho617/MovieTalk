//
//  LoginDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation

struct LoginRequestDTO: Encodable{
    let email: String
    let password: String
}

struct LoginResponseDTO: Decodable{
    let token: String
    let refreshToken: String
    let _id: String
}
