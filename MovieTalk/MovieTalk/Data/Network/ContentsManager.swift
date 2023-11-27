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
                        print(String(data: response.data, encoding: .utf8))
                    }else{
                        print("Sesac Failure", response.statusCode)
                        print(String(data: response.data, encoding: .utf8) ?? "")
                        observer.onNext(false)
                    }
                    observer.onCompleted() //해제
                case .failure(let error):
                    print("Sesac Failure", error)
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetch() -> Observable<ContentsReadResponseDTO>{
        return Observable<ContentsReadResponseDTO>.create { observer in
            print("ContentsManager: fetch()")
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.readTopic) { result in
                switch result{
                case .success(let response):
                    print("SESAC SUCCESS",response.statusCode)
                    print(String(data: response.data, encoding: .utf8))
                    if let decodedResponse = try? JSONDecoder().decode(ContentsReadResponseDTO.self, from: response.data){
                        observer.onNext(decodedResponse)
                    }else{
                        print("Contents: Decoding Failed")
                    }
                case .failure(let error):
                    print("FAILURE",error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    
}
