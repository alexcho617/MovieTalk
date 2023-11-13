//
//  LoginViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//

import UIKit

class LoginViewController: UIViewController {
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        viewModel.login()
    }
    
}
