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
    
    //TODO: Add error handling codes
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
    
    func likePost(_ id: String) -> Observable<Bool>{
        return Observable<Bool>.create { observer in
            print("ContentsManager:", #function)
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.likeTopic(postId: id)) { result in
                switch result{
                case .success(let response):
                    if response.statusCode == 200{
                        observer.onNext(true)
                        observer.onCompleted()
                    }else{
                        print(response.statusCode)
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onNext(false)
                    handleStatusCodeError(error)
                    observer.onCompleted()
                    
                }
            }
            return Disposables.create()
        }

    }
    
}
