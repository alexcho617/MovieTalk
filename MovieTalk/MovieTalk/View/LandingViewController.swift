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
        view.text = "MovieTalk"
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
                    
                    let tabBarController = UITabBarController()
                    let homeVC = UINavigationController(rootViewController: HomeViewController())
                    let addVC = UINavigationController(rootViewController: SearchViewController())
                    let devVC = UINavigationController(rootViewController: SettingsViewController())
                    
                    tabBarController.setViewControllers([homeVC, addVC, devVC], animated: true)
                    tabBarController.tabBar.tintColor = .systemIndigo
                    
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.backgroundColor = .systemBackground
                    tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance //끝에 있을때: 맨 아래로 내려가있을때
                    tabBarController.tabBar.standardAppearance = tabBarAppearance //끝에 닿지 않을때 NavigationBar랑 반대임
                    
                    if let items = tabBarController.tabBar.items{
                        items[0].image = UIImage(systemName: "house.fill")
                        items[0].title = "홈"
                        
                        items[1].image = UIImage(systemName: "plus")
                        items[1].title = "Add"
                        
                        items[2].image = UIImage(systemName: "person")
                        items[2].title = "개발"
                    }
                    //                    print("Go to home")
                    self.navigator(tabBarController)
                default:
                    //                    print("Login")
                    self.navigator(LoginViewController())
                    
                }
            }.disposed(by: disposeBag)
    }
    
    func navigator(_ vc: UIViewController){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
