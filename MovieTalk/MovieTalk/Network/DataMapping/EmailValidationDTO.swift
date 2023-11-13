//
//  EmailValidationDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation

struct EmailValidationRequestDTO: Encodable{
    let email: String
}


struct EmailValidationResponseDTO: Decodable{
    let message: String
}
