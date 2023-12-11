//
//  ContentsManager.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/20.
//

import Foundation
import RxMoya
import Moya
import RxSwift
import UIKit

final class ContentsManager{
    static let shared = ContentsManager()
    private init(){}
    let disposeBag = DisposeBag()
    //TODO: Add error handling codes -> 각 함수에 token refresh 넣기. 전부 refresh 호출해버리면 되는거 아닌가? 갱신 성공, 만료 안됨 말고는싹다 리턴
    func post(_ model: ContentsCreateRequestDTO) -> Observable<Bool>{
        return Observable<Bool>.create { observer in
            print("ContentsManager: post()")
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.createTopic(model: model)) { result in
                switch result{
                case .success(let response):
                    if response.statusCode == 200{
                        observer.onNext(true)
                        observer.onCompleted() //해제
//                        print(String(data: response.data, encoding: .utf8))
                    }else{
                        print("Sesac Failure", response.statusCode)
                        print(String(data: response.data, encoding: .utf8) ?? "")
                        observer.onNext(false)
                    }
                    observer.onCompleted() //해제
                case .failure(let error):
                    observer.onNext(false)
                    handleStatusCodeError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetch(nextCursor: String) -> Observable<ContentsReadResponseDTO>{
        return Observable<ContentsReadResponseDTO>.create { observer in
            print("ContentsManager: fetch()")
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.readTopic(next: nextCursor)) { result in
                switch result{
                case .success(let response):
                    print("SESAC Contents SUCCESS",response.statusCode)
//                    print(String(data: response.data, encoding: .utf8))
                    if let decodedResponse = try? JSONDecoder().decode(ContentsReadResponseDTO.self, from: response.data){
                        observer.onNext(decodedResponse)
                    }else{
                        print("Contents: Decoding Failed") //에러시 빈값 전달
                        observer.onNext(ContentsReadResponseDTO.emptyResponse())
                    }
                case .failure(let error):
                    observer.onNext(ContentsReadResponseDTO.emptyResponse())
                    handleStatusCodeError(error)

                }
            }
            return Disposables.create()
        }
        
    }
    
    func fetchPostFile(_ path: String) -> Observable<UIImage>{
        return Observable<UIImage>.create { observer in
            print("ContentsManager: fetchPostFile()")
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.getImage(imagePath: path)) { result in
                switch result{
                case .success(let response):
                    if let decodedImage = UIImage(data: response.data){
                        observer.onNext(decodedImage)
                    }else{
                        observer.onNext(UIImage(systemName: "photo")!) //에러시 기본 이미지 전달
                    }
                case .failure(let error):
                    observer.onNext(UIImage(systemName: "photo")!)
                    handleStatusCodeError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func likePost(_ id: String, completion: @escaping (Bool) -> Void ){
        print("ContentsManager:", #function)
        var likedResult: Bool = false
        let provider = MoyaProvider<ContentsServerAPI>()
        
        provider.request(ContentsServerAPI.likeTopic(postId: id)) { result in
            switch result{
            case .success(let response):
//                print(response.statusCode, String(data: response.data, encoding: .utf8))
                if response.statusCode == 200{
                    //토글방식이기 때문에 어차피 200 이면 정상 처리 된거라 디코딩 값이 필요없음
//                    let decodedResponse = try? JSONDecoder().decode(LikedReponseDTO.self, from: response.data)
                    likedResult = true
                }else{
                    likedResult = false
                }
            case .failure(let error):
                likedResult = false
                handleStatusCodeError(error)
            }
            completion(likedResult)
        }
    }
    
    func addComment(_ model: CommentCreateRequestDTO, _ postId: String) -> Observable<Comment>{
        print(#function, model, postId)
        return Observable<Comment>.create { observer in
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.createComment(model: model, postId: postId)) { result in
                switch result{
                case .success(let response):
                    if response.statusCode == 200{
                        if let decodedComment = try? JSONDecoder().decode(Comment.self, from: response.data){
                            observer.onNext(decodedComment)
                        }else{
                            print("Decoding Failed: Status code:", response.statusCode)
                            observer.onNext(CommentCreateResponseDTO.emptyResponse())
                        }
                        
                    }else{
                        print("Server Failed: Status code:", response.statusCode)
                        print(String(data: response.data, encoding: .utf8) ?? "")
                        observer.onNext(CommentCreateResponseDTO.emptyResponse())
                    }
                case .failure(let error):
                    handleStatusCodeError(error)
                    observer.onNext(CommentCreateResponseDTO.emptyResponse())
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func editProfile(_ model: MyProfileEditRequestDTO) -> Observable<MyProfileReadResponseDTO>{
        return Observable<MyProfileReadResponseDTO>.create { observer in
            print("ContentsManager: post()")
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.editMyProfile(model: model)) { result in
                switch result{
                case .success(let response):
//                    print(String(data: response.data, encoding: .utf8))
                    if response.statusCode == 200{
                        if let decodedData = try? JSONDecoder().decode(MyProfileReadResponseDTO.self, from: response.data){
                            observer.onNext(decodedData)
                        }else{
                            print("Decoding Failure")
                            observer.onNext(.emptyRepsonse())
                        }

                    }else{
                        print("Server Failure", response.statusCode)
                        print(String(data: response.data, encoding: .utf8) ?? "")
                        observer.onNext(.emptyRepsonse())
                    }
                case .failure(let error):
                    observer.onNext(.emptyRepsonse())
                    handleStatusCodeError(error)
                }
                observer.onCompleted() //해제
            }
            return Disposables.create()
        }
    }
    
}// End of Class Declaration
