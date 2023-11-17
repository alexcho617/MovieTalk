//
//  LandingViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/14.
//

import UIKit

//TODO: Auth manager참조 여기서 해서 login/home/signup 분기처리하기
final class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        routeview()

    }
    
    func routeview(){
        //1 get token from userdefautls
        let token = UserDefaultsManager.shared.currentToken
        let refresh = UserDefaultsManager.shared.currentRefreshToken
        
        //2 check token validation
        //how to check token validation? with content?
        //refresh에서 주는 상태코드로 분기처리

        //2-1 token is valid
        //go to Home
        
        //2-2 token is invalid
        //3 try refresh
        //3-1 refresh worked
        //4validate new token
        //go to home
        //3-2 refresh didnt work
        //go to login
        
    }
    
}
