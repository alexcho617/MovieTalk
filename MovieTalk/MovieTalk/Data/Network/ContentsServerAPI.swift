//
//  ContentsServerAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/21.
//

import Foundation
import Moya

//일단 만드려는 화면부터 확실히 해야할듯
//최상위 토픽을 영화로 할 지 아니면 그냥 토픽으로 하고 영화별로 토픽을 필터링 할 수 있게 한다면 post{content1: tmdbMovieID} 이런식으로 가야할듯

//이거랑 별개로 트렌딩 화면을 위해선 각 포스트 들의 컨텐츠에 들어갈 영화에 대한 카운트도 필요 할 것 같음.
//그렇다면 Product ID를 사용자들의 SNS 포스팅용 하나, 그리고 영화에 대한것 하나 해야할듯. 영화에 대한 테이블에는 좋아요나 이런 기능은 필요 없을것같고 product id 를 movie id로 일치 시킨 후 태그 된 갯수, 아니면 팔로우 수 같은걸 보여주면 좋을것 같음.

//MARK: 영화 Data 관리할 Table: ProductID -> mtMovie
//MARK: 사용자의 SNS Data 관리할 Table: ProductID -> mtSNS
enum ContentsServerAPI{
    case createTopic
//    case readTopic
//    case editTopic
//    case deleteTopic
    
//    case createComment
//    case editComment
//    case deleteComment
    
    //toggle like<>dislike
//    case likeTopic
}

extension ContentsServerAPI: TargetType{
    var baseURL: URL {
        Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .createTopic:
            return "post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTopic:
            return .post
        }
    }
    
    /*
     content
     더 레전드 오브 더 전설의 시작

     product_id
     movietalk_topic

     title
     해리포터와 마법사의 돌

     content1
     J.K.Rowling

     
     */
    
    var task: Moya.Task {
        switch self {
        case .createTopic:
            //TODO: make dto model and pass it
            var multiPartData: [Moya.MultipartFormData] = []
            
            let productIDData = "mtSNS".data(using: .utf8) ?? Data()
            let titleData = "해리포터를 봤다".data(using: .utf8) ?? Data()
            let contentData = "해리포터는 정말 명작이야 보고 또 봐도 질리지 않아.".data(using: .utf8) ?? Data()
            let contentOneData = "https://www.themoviedb.org/movie/671-harry-potter-and-the-philosopher-s-stone?language=ko".data(using: .utf8) ?? Data()
            
            let image = Image(named: "stone")
            

            //            let fileData data 타입 일단 쿼리부터 날려보자
            multiPartData.append(MultipartFormData(provider: .data(productIDData), name: "product_id"))
            multiPartData.append(MultipartFormData(provider: .data(titleData), name: "title"))
            multiPartData.append(MultipartFormData(provider: .data(contentData), name: "content"))
            multiPartData.append(MultipartFormData(provider: .data(contentOneData), name: "content1"))
            multiPartData.append(MultipartFormData(provider: .data((image?.jpegData(compressionQuality: 1.0))!), name: "file",fileName: "stone.png", mimeType: "image/png"))
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createTopic:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "Content-Type" : "multipart/form-data",
                "SesacKey" : Secret.key
            ]
        }
    }
    
    
}
