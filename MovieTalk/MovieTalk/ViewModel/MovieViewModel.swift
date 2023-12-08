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
    var disposeBag =  DisposeBag()
    struct Input{
        let didClickExpand: ControlEvent<Void>
        let movieID: String
    }
    
    struct Output{
        let isExpanded: BehaviorRelay<Bool>
        let movieData: PublishRelay<MovieResponseDTO>
        let movieImages: PublishRelay<[MovieImage]>
    }
    func transform(input: Input) -> Output {
        var isExpand = false
        let movieContents = PublishRelay<MovieResponseDTO>()
        let movieImages = PublishRelay<[MovieImage]>()

        let isExpandedRelay = BehaviorRelay(value: false)
        
        input.didClickExpand
            .subscribe { _ in
                isExpand.toggle()
                isExpandedRelay.accept(isExpand)
            }
            .disposed(by: disposeBag)
            
        
        let movieObservable = {
            return Observable<MovieResponseDTO>.create { observer in
                let provider = MoyaProvider<MovieAPI>()
                
                print("DEBUG MovieViewModel movieID:",input.movieID)
                provider.request(MovieAPI.lookUp(id: input.movieID)) { result in
                    switch result{
                    case .success(let response):
                        if response.statusCode == 200{
                            print("TMDB SUCCESS", response.statusCode)
                            if let decodedResponse = try? JSONDecoder().decode(MovieResponseDTO.self, from: response.data){
                                observer.onNext(decodedResponse)
                                observer.onCompleted() //해제
                            }else{
                                print("Movie Decoding Failed")
                            }
                        }else{
                            print("TMDB FAilure", response.statusCode)
                            print(String(data: response.data, encoding: .utf8) ?? "")
                        }
                        observer.onCompleted() //해제
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
        
        ///
        ///Images API
        let movieImagesObservable = {
            return Observable<[MovieImage]>.create { observer in
                let provider = MoyaProvider<MovieAPI>()
                
                provider.request(MovieAPI.images(id: input.movieID)) { result in
                    switch result{
                    case .success(let response):
                        if response.statusCode == 200{
                            print("TMDB IMAGES SUCCESS", response.statusCode)
                            if let decodedResponse = try? JSONDecoder().decode(MovieImageResponse.self, from: response.data){
                                guard let backdrops = decodedResponse.backdrops else { return }
                                let filtered = backdrops.filter { movie in
                                    movie.iso639_1 == "en" || movie.iso639_1 == nil
                                }
                                observer.onNext(filtered)
                                observer.onCompleted() //해제
                            }else{
                                print("Movie Images Decoding Failed")
                            }
                        }else{
                            print("TMDB FAilure", response.statusCode)
                            print(String(data: response.data, encoding: .utf8) ?? "")
                        }
                        observer.onCompleted() //해제
                    case .failure(let error):
                        print("TMDB FAilure")
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
        
        movieImagesObservable()
            .subscribe(with: self) { owner, response in
                movieImages.accept(response)
            }
            .disposed(by: disposeBag)
        ///
        let output = Output(isExpanded: isExpandedRelay, movieData: movieContents, movieImages: movieImages)
        return output
    }
    
    
}
