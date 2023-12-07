//
//  MovieImageDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/7/23.
//
import Foundation

// MARK: - MovieImageResponse
struct MovieImageResponse: Codable, Hashable {
    let backdrops: [MovieImage]?
    let id: Int?
    let logos, posters: [MovieImage]?
}

// MARK: - Backdrop
struct MovieImage: Codable, Hashable {
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount, width: Int?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
