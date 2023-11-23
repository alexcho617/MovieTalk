//
//  MovieViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class MovieViewModel: ViewModel{
    var movieID: String = ""
    var disposeBag =  DisposeBag()
    
    struct Input{
        
    }
    
    struct Output{
        let movieContents: PublishRelay<MovieResponseDTO>
    }
    func transform(input: Input) -> Output {
        let movieContents = PublishRelay<MovieResponseDTO>()

        let movieObservable = {
            return Observable<MovieResponseDTO>.create { observer in
                let provider = MoyaProvider<MovieAPI>()
                provider.request(MovieAPI.lookUp(id: self.movieID)) { result in
                    switch result{
                    case .success(let response):
                        print("TMDB SUCCESS", response.statusCode)
                        if let decodedResponse = try? JSONDecoder().decode(MovieResponseDTO.self, from: response.data){
                            observer.onNext(decodedResponse)
                        }else{
                            print("Movie Decoding Failed")
                        }
                    case .failure(let error):
                        print("TMDB FAilure")
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
        
        movieObservable()
            .subscribe(with: self) { owner, response in
                movieContents.accept(response)
            }
            .disposed(by: disposeBag)
        let output = Output(movieContents: movieContents)
        return output
    }
    
    
}
