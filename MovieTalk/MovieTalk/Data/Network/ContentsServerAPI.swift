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
    case createTopic(model: ContentsCreateRequestDTO)
    case readTopic
    case getImage(imagePath: String)
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
        case .createTopic, .readTopic:
            return "post"
        case .getImage(let imagePath):
            return imagePath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTopic:
            return .post
        case .readTopic, .getImage:
            return .get
        }
    }
    
    
    var task: Moya.Task {
        switch self {
        case .createTopic(let model):
            var multiPartData: [Moya.MultipartFormData] = []
            let productIDData = model.product_id.data(using: .utf8) ?? Data()
            let titleData = model.title.data(using: .utf8) ?? Data()
            let contentData = model.content.data(using: .utf8) ?? Data()
            let fileData = model.file ?? Data()
            
            multiPartData.append(MultipartFormData(provider: .data(productIDData), name: "product_id"))
            multiPartData.append(MultipartFormData(provider: .data(titleData), name: "title"))
            multiPartData.append(MultipartFormData(provider: .data(contentData), name: "content"))
            
            //binary데이터: fileName, mimeType 값 필요함
            multiPartData.append(MultipartFormData(provider: .data(fileData), name: "file",fileName: "placeholder.png", mimeType: "image/png"))
            
            //movie id
            if let content1: String = model.content1{
                let data = content1.data(using: .utf8) ?? Data()
                multiPartData.append(MultipartFormData(provider: .data(data), name: "content1"))
            }
            
            //movie name
            if let content2: String = model.content2{
                let data = content2.data(using: .utf8) ?? Data()
                multiPartData.append(MultipartFormData(provider: .data(data), name: "content2"))
            }
            
            if let content3: String = model.content3{
                let data = content3.data(using: .utf8) ?? Data()
                multiPartData.append(MultipartFormData(provider: .data(data), name: "content3"))
            }
            
            if let content4: String = model.content4{
                let data = content4.data(using: .utf8) ?? Data()
                multiPartData.append(MultipartFormData(provider: .data(data), name: "content4"))
            }
            
            if let content5: String = model.content5{
                let data = content5.data(using: .utf8) ?? Data()
                multiPartData.append(MultipartFormData(provider: .data(data), name: "content5"))
            }
            
            multiPartData.map({ data in
                print(data)
            })
            
            return .uploadMultipart(multiPartData)
        case .readTopic: //TODO: next limit parameter, use enum to abstact
            return .requestParameters(parameters: ["product_id" : "mtSNS"], encoding: URLEncoding.default)
        case .getImage:
            return .requestParameters(parameters: ["product_id" : "mtSNS"], encoding: URLEncoding.default)
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
        case .readTopic, .getImage:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "SesacKey" : Secret.key
            ]
        }
    }
    
    
}
