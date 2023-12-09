//
//  PostDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/19.
//

import Foundation


struct Comment: Codable, Equatable{
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs._id == rhs._id &&
                    lhs.content == rhs.content &&
                    lhs.creator == rhs.creator &&
                    lhs.time == rhs.time
    }
    
    let _id: String
    let content: String
    let time: String
    let creator: Creator
}

struct Creator: Codable, Equatable{
    let _id: String
    let nick: String
    let profile: String?
}

//MARK: Create
//create request
/*
 file = 포스터나 백드롭 이미지
 content1 = 영화 아이디
 content2 = 영화 제목
 */
struct ContentsCreateRequestDTO: Encodable{
    let title: String //글 제목
    let content: String //글 내용
    let file: Data? //영화 이미지 Data
    let product_id: String //mtSNS
    let content1: String? // 영화 아이디
    let content2: String? // 영화 제목
    let content3: String? // 안씀
    let content4: String? // 안씀
    let content5: String? // 안씀
}

//create response
struct ContentsCreateResponseDTO: Decodable{
    let likes: [String]
    let image: [String]
    let hashtags: [String]
    let comments: [Comment]
    let _id: String
    let creator: Creator
    let time: String
    let content: String
    let product_id: String
}



//MARK: Read
//read request

//read response
//{
//    "data": [
//        {
//            "likes": [],
//            "image": [],
//            "hashTags": [],
//            "comments": [],
//            "_id": "655725d523460125d48a1ba2",
//            "creator": {
//                "_id": "6556dbbe8a6d7823a12848ca",
//                "nick": "alex"
//            },
//            "time": "2023-11-17T08:35:33.317Z",
//            "title": "해리포터와 마법사의 돌",
//            "content": "더 레전드 오브 더 전설의 시작",
//            "content1": "J.K.Rowling",
//            "content2": "Daniel Radcliff",
//            "product_id": "movietalk_topic"
//        }
//    ],
//    "next_cursor": 0
//}


struct ContentsReadResponseDTO: Decodable {
    let data: [Post]
    let next_cursor: String?
    
    static func emptyResponse() -> ContentsReadResponseDTO{
        return ContentsReadResponseDTO(data: [], next_cursor: "0")
    }
}

struct Post: Decodable {
    let id: String
    var comments: [Comment]?
    let content: String
    let movieID: String?
    let movieTitle: String?
    let moviePosterURL: String?
    let creator: Creator
    let hashTags: [String]
    let image: [String]?
    let likes: [String]?
    let productID: String
    let time: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comments, content, creator, hashTags, image, likes
        case movieID = "content1"
        case movieTitle = "content2"
        case moviePosterURL = "content3"
        case productID = "product_id"
        case time, title
    }
}




//MARK: Update

//MARK: Delete


//MARK: Like Post
struct LikedReponseDTO: Decodable{
    let like_status: Bool
}

//MARK: Comment
struct CommentCreateRequestDTO: Encodable{
    let content: String
}

struct CommentCreateResponseDTO: Decodable{
    let comment: Comment
    
    static func emptyResponse() -> Comment{
        return Comment(_id: "", content: "", time: "", creator: Creator(_id: "", nick: "", profile: nil))
    }
}
//Update
//Delete
