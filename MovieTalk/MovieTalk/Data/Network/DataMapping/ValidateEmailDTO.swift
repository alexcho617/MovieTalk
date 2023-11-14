//
//  EmailValidationDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import Foundation

struct ValidateEmailRequestDTO: Encodable{
    let email: String
}


struct ValidateEmailResponseDTO: Decodable{
    let message: String
}
