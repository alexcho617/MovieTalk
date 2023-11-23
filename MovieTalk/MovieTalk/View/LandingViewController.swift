//
//  LandingViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
final class LandingViewController: UIViewController {
    private var loadingText = {
        let view = UILabel()
        view.text = "로딩중..."
        return view
    }()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(loadingText)
        loadingText.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    func bind(){
        AuthManager.shared.currentAuthState
            .withLatestFrom(AuthManager.shared.refresh())
            .subscribe(with: self) { owner, state in
                switch state{
                case .loggedIn:
                    self.navigator(HomeViewController())
                default:
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
