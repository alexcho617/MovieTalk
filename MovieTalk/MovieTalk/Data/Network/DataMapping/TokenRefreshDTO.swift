//
//  TokenRefreshDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation

//Request Entity 없음, 헤더에서 처리
//struct TokenRefreshRequestDTO: Encodable{
//
//}

struct TokenRefreshResponseDTO: Decodable{
    let token: String
}
