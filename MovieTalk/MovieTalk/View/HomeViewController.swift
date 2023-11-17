//
//  HomeViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    var logoutButton = {
        let view = UIButton(type: .system)
        view.setTitle("로그아웃", for: .normal)
        return view
    }()
    
    var withdrawButton = {
        let view = UIButton(type: .system)
        view.setTitle("회원탈퇴", for: .normal)
        return view
    }()
    
    var tokenRefreshButton = {
        let view = UIButton(type: .system)
        view.setTitle("토큰갱신", for: .normal)
        return view
    }()
    
    var contentsButton = {
        let view = UIButton(type: .system)
        view.setTitle("콘텐츠 불러오기", for: .normal)
        return view
    }()
    
    var contentsLabel = {
        let view = UILabel()
        view.text = "값을 불러오세요"
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //todo logout
        //withdraw
        setView()
        bind()
    }
    
    func setView(){
        title = "HOME"
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(withdrawButton)
        view.addSubview(tokenRefreshButton)
        view.addSubview(contentsButton)
        view.addSubview(contentsLabel)
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        tokenRefreshButton.snp.makeConstraints { make in
            make.top.equalTo(withdrawButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        contentsButton.snp.makeConstraints { make in
            make.top.equalTo(tokenRefreshButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }
     @objc
     func logout(){
         //delete all token
         UserDefaultsManager.shared.clearToken()
         
         let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
         let sceneDelegate = windowScene?.delegate as? SceneDelegate
         let nav = UINavigationController(rootViewController: LoginViewController())
         sceneDelegate?.window?.rootViewController = nav
         sceneDelegate?.window?.makeKeyAndVisible()
     }
    func bind(){
        
    }
}

