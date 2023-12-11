//
//  ProfileViewModel.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/2/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class ProfileViewModel: ViewModel{
    
    var disposeBag = DisposeBag()
    let profileRelay = BehaviorRelay(value: MyProfileReadResponseDTO.emptyRepsonse())
    let postRelay: BehaviorRelay<[Post]> = BehaviorRelay(value: [])
    struct Input{
    }
    
    struct Output{
        let myprofileRelay: BehaviorRelay<MyProfileReadResponseDTO>
        let mypostRelay: BehaviorRelay<[Post]>
        
    }
    
    func transform(input: Input) -> Output {
       

        let profileObserver = {
            return Observable<MyProfileReadResponseDTO>.create { observer in
                let provider = MoyaProvider<ContentsServerAPI>()
                provider.request(.myProfile) { [self] result in
                    switch result{
                    case .success(let response):
                        let statusCode = response.statusCode
                        print(response.statusCode)
                        if statusCode == 200{
                            let decodedResponse = try? JSONDecoder().decode(MyProfileReadResponseDTO.self, from: response.data)
                            profileRelay.accept(decodedResponse ?? .emptyRepsonse()) //TODO: 여기서 바로 주면 안되고 변수를 하나 더 만들어서 전달해야함. 바로줄꺼면 이렇게 따로 뺄 이유가 없음
                        }else{
                            //invalid status code
                            print(statusCode)
                            profileRelay.accept(.emptyRepsonse())
                        }
                    case .failure(let error):
                        print("Profile Fail",error)
                        profileRelay.accept(.emptyRepsonse())

                    }
                }
                
                return Disposables.create()
            }
        }
        
        let postObserver = {
            return Observable<ContentsReadResponseDTO>.create { observer in
                let provider = MoyaProvider<ContentsServerAPI>()
                provider.request(.readUserTopic(userID: UserDefaultsManager.shared.currentUserID, next: "")) { [self] result in
                    switch result{
                    case .success(let response):
                        let statusCode = response.statusCode
                        if statusCode == 200{
                            let decodedResponse = try? JSONDecoder().decode(ContentsReadResponseDTO.self, from: response.data)
                            postRelay.accept(decodedResponse?.data ?? []) //TODO: 여기서 바로 주면 안되고 변수를 하나 더 만들어서 전달해야함. 바로줄꺼면 이렇게 따로 뺄 이유가 없음
                        }else{
                            //invalid status code
                            print(statusCode)
                            postRelay.accept([])
                        }
                    case .failure(let error):
                        print("MyPost Read Fail",error)
                        postRelay.accept([])

                    }
                }
                
                return Disposables.create()
            }
        }
        
        profileObserver() //이미 생성 시점에서 이벤트 전달을 했는데 밑의 바인드가 꼭 필요한건가?
            .bind { [self] response in
                profileRelay.accept(response)
            }
            .disposed(by: disposeBag)
        
        postObserver()
            .bind { [self] response in
                postRelay.accept(response.data)
            }
            .disposed(by: disposeBag)
        
        
        let output = Output(myprofileRelay: profileRelay, mypostRelay: postRelay)
        return output
    }
    
    //edit 요청 후 받아온 응답 profileRelay에 전달
    func editProfile(model: MyProfileEditRequestDTO){
        ContentsManager.shared.editProfile(model)
            .subscribe(with: self) { owner, newProfile in
                owner.profileRelay.accept(newProfile)
            }
            .disposed(by: disposeBag)
    }
}
