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

class SettingsViewController: UIViewController {
    let viewModel = SettingsViewModel()
    let disposeBag = DisposeBag()
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        bind()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoutButton)
        view.addSubview(withdrawButton)
        view.addSubview(tokenRefreshButton)
        
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
        
    }
    
     func logout(){
         //delete all token
         UserDefaultsManager.shared.clearToken()
         
         //rootview swap
         let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
         let sceneDelegate = windowScene?.delegate as? SceneDelegate
         let nav = UINavigationController(rootViewController: LoginViewController())
         sceneDelegate?.window?.rootViewController = nav
         sceneDelegate?.window?.makeKeyAndVisible()
     }
    
    func bind(){
        let input = SettingsViewModel.Input(logoutClicked: logoutButton.rx.tap, withdrawClicked: withdrawButton.rx.tap, refreshClicked: tokenRefreshButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        //여기서 이벤트 계속 발생 중
        output.authStatus
            .drive { state in
                if state == .loggedOut{
                    self.logout()
                }
            }
            .disposed(by: disposeBag)
    }
}

