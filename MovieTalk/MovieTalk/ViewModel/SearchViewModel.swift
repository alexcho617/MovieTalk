//
//  AddViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/25/23.
//
import Foundation
import RxCocoa
import RxSwift
import Moya

class SearchViewModel: ViewModel {
    var disposeBag = DisposeBag()
    
    struct Input {
        let searchQueryEntered: ControlProperty<String>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let searchResult: Driver<[MovieResponseDTO]>
        let scrollToTop: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = BehaviorRelay<[MovieResponseDTO]>(value: [])
        let scrollToTop = PublishRelay<Void>()

        let movieSearchObservable = input.searchButtonClicked
            .withLatestFrom(input.searchQueryEntered.asObservable())
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                return self.fetchMovies(query: query)
            }
            .asDriver(onErrorDriveWith: .empty())
      
        movieSearchObservable
            .drive(onNext: { movies in
                searchResult.accept(movies)
                if !movies.isEmpty {
                    scrollToTop.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        //create another observalbe from trends api and send it to movies
        let movieTrendObservable = fetchTrendingMovies()
        movieTrendObservable
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, movies in
                searchResult.accept(movies)
            }
            .disposed(by: disposeBag)
        
        return Output(searchResult: searchResult.asDriver(onErrorJustReturn: []), scrollToTop: scrollToTop.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func fetchMovies(query: String) -> Observable<[MovieResponseDTO]> {
        return Observable.create { observer in
            let provider = MoyaProvider<MovieAPI>()
            provider.request(MovieAPI.search(query: query)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        if let decodedResponse = try? JSONDecoder().decode(MovieSearchReponseDTO.self, from: response.data) {
                            print(decodedResponse.results.count, "movies fetched")
                            observer.onNext(decodedResponse.results)
                        } else {
                            print("Movie Decoding Failed")
                            observer.onNext([])
                        }
                    } else {
                        print("TMDB Failure", response.statusCode)
                        print(String(data: response.data, encoding: .utf8) ?? "")
                        observer.onNext([])
                    }
                case .failure(let error):
                    print("TMDB Failure", error)
                    observer.onNext([])
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func fetchTrendingMovies() -> Observable<[MovieResponseDTO]> {
        print("TREND",#function)
        return Observable.create { observer in
            let provider = MoyaProvider<MovieAPI>()
            provider.request(MovieAPI.trend) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        if let decodedResponse = try? JSONDecoder().decode(MovieSearchReponseDTO.self, from: response.data) {
                            print(decodedResponse.results.count, "개")
                            observer.onNext(decodedResponse.results)
                            observer.onCompleted()
                        } else {
                            print("Movie Decoding Failed")
                        }
                    } else {
                        print("TMDB Failure", response.statusCode)
                        print(String(data: response.data, encoding: .utf8) ?? "")
                        observer.onNext([])
                    }
                case .failure(let error):
                    print("TMDB Failure", error)
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
}
