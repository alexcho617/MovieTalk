//
//  ContentsServerAPI.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/21.
//

import Foundation
import Moya

enum ContentsServerAPI{
    case createTopic(model: ContentsCreateRequestDTO)
    case readTopic(next: String)
    case getImage(imagePath: String)

    //나중에 추가 될 수 있는 루트들
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
            
            //DEBUG
//            multiPartData.map({ data in
//                print(data)
//            })
            
            return .uploadMultipart(multiPartData)
        case .readTopic(let next):
            let queryParameters = [
                "product_id" : "mtSNS",
                "limit" : "10",
                "next" : next
            ]
            return .requestParameters(parameters: queryParameters, encoding: URLEncoding.default)
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
