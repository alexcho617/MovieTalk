//
//  ErrorDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import Foundation

struct ErrorResponseDTO: Decodable {
    var code: Int?
    let message: String
}
