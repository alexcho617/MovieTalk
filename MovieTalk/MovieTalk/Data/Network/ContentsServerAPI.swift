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
    case readUserTopic(userID: String, next: String)

    //나중에 추가 될 수 있는 루트들
//    case editTopic
//    case deleteTopic
    
    case createComment(model: CommentCreateRequestDTO, postId: String)
//    case editComment
//    case deleteComment
    
    case likeTopic(postId: String)
    
    //profiles
    case myProfile
    case editMyProfile(model: MyProfileEditRequestDTO)
}

extension ContentsServerAPI: TargetType{
    var baseURL: URL {
        Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .createTopic, .readTopic:
            return "post"
            
        case .readUserTopic(userID: let userID, next: _):
            let path = "post/user/\(userID)"
            return path
        case .getImage(let imagePath):
            return imagePath
            
        case .likeTopic(postId: let postId):
            return "post/like/\(postId)"
            
        case .createComment(model: _, postId: let id):
            let completeURL = "post/\(id)/comment"
            return completeURL
        
        case .myProfile, .editMyProfile:
            return "profile/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTopic, .likeTopic, .createComment:
            return .post
        case .readTopic, .getImage, .myProfile, .readUserTopic:
            return .get
        case .editMyProfile:
            return .put
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
                
        case .readUserTopic(userID: _ , next: let next):
            let queryParameters = [
                "product_id" : "mtSNS",
                "limit" : "10",
                "next" : next
            ]
            return .requestParameters(parameters: queryParameters, encoding: URLEncoding.default)
        
        case .getImage:
            return .requestParameters(parameters: ["product_id" : "mtSNS"], encoding: URLEncoding.default)
            
        case .likeTopic:
            return .requestPlain
        
        case .createComment(model: let model , postId: _):
            return .requestJSONEncodable(model)
            
        case .myProfile:
            return .requestPlain
            
        case .editMyProfile(model: let model):
            var multiPartData: [Moya.MultipartFormData] = []
            let nicknameData = model.nick?.data(using: .utf8) ?? Data()
            let birthdayData = model.birthDay?.data(using: .utf8) ?? Data()
            let phoneData = model.phoneNum?.data(using: .utf8) ?? Data()
            let fileData = model.profile ?? Data() //1MB 미만 이어야함
//            if fileData.count > 1000000 {
//
//                print("File too large")
//            }
            
            multiPartData.append(MultipartFormData(provider: .data(nicknameData), name: "nick"))
            multiPartData.append(MultipartFormData(provider: .data(birthdayData), name: "birthDay"))
            multiPartData.append(MultipartFormData(provider: .data(phoneData), name: "phoneNum"))
            //binary데이터: fileName, mimeType 값 필요함
            multiPartData.append(MultipartFormData(provider: .data(fileData), name: "profile",fileName: "profile.png", mimeType: "image/png"))
            
            
//            DEBUG
//            multiPartData.map({ data in
//                print(data)
//            })
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createTopic, .editMyProfile:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "Content-Type" : "multipart/form-data",
                "SesacKey" : Secret.key
            ]
        case .readTopic, .readUserTopic, .getImage, .likeTopic, .myProfile:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "SesacKey" : Secret.key
            ]
        case .createComment:
            return [
                "Authorization" : UserDefaultsManager.shared.currentToken,
                "Content-Type" : "application/json",
                "SesacKey" : Secret.key
            ]
        }
    }
    
    
}
