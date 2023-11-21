//
//  PostDTO.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/19.
//

import Foundation


struct Comment: Codable{
    
}

struct Creator: Codable{
    let _id: String
    let nick: String
}

//MARK: Create
//create request
/*
 content1 = 영화 아이디
 content2 = 영화 제목
 content3 = 영화 포스터 TMDB 주소
 */
struct ContentsCreateRequestDTO: Encodable{
    let title: String
    let content: String
    let file: Data
    let product_id: String
    let content1: String? // movie id
    let content2: String? // movie title
    let content3: String? // movie poster
    let content4: String?
    let content5: String?
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
//Hashable 해야함
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


//MARK: Update

//MARK: Delete