//
//  LandingViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import UIKit
import RxSwift
import RxCocoa

//TODO: Auth manager참조 여기서 해서 login/home/signup 분기처리하기
final class LandingViewController: UIViewController {
//    let vm = LandingViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Landing Viewdidload")
        bind()

    }
    
    func bind(){
//        print(#function)
        AuthManager.shared.currentAuthState
            .withLatestFrom(AuthManager.shared.refresh())
            .subscribe(with: self) { owner, state in
                switch state{
                case .loggedIn:
//                    print("Go to home")
                    self.navigator(HomeViewController())
                default:
//                    print("Login")
                    self.navigator(LoginViewController())

                }
            }.disposed(by: disposeBag)
    }
    
    func navigator(_ vc: UIViewController){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let nav = UINavigationController(rootViewController: vc)
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
