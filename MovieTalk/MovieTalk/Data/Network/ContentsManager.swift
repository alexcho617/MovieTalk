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
    func post(_ model: ContentsCreateRequestDTO){
        print("ContentsManager: post()")
        let provider = MoyaProvider<ContentsServerAPI>()
        provider.request(ContentsServerAPI.createTopic(model: model)) { result in
            switch result{
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                print("SUCCESS:",statusCode,data)
                print(response.data.description)
                
            case .failure(let error):
                print("FAILURE",error)
            }
        }
    }
    
    func fetch() -> Observable<ContentsReadResponseDTO>{
        return Observable<ContentsReadResponseDTO>.create { observer in
            print("ContentsManager: fetch()")
            let provider = MoyaProvider<ContentsServerAPI>()
            provider.request(ContentsServerAPI.readTopic) { result in
                switch result{
                case .success(let response):
                    print("SUCCESS",response.statusCode)
                    let decodedResponse = try! JSONDecoder().decode(ContentsReadResponseDTO.self, from: response.data)
                    observer.onNext(decodedResponse)
                case .failure(let error):
                    print("FAILURE",error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    
}
