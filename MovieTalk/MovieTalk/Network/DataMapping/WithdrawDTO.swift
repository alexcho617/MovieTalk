//
//  WithdrawDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation

struct WithdrawRequestDTO: Encodable{
    let email: String
    let password: String
}

struct WithdrawResponseDTO: Decodable{
    let _id: String
    let _email: String
    let nick: String
}
