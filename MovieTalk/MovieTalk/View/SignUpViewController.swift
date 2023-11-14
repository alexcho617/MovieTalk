//
//  SignupViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func bind(){
        let input = SignUpViewModel.Input(email: emailTextField.rx.text.orEmpty, password: passwordTextField.rx.text.orEmpty, signUpButtonClicked: signUpButton.rx.tap)
        
        let output = viewModel.transform(input: input)

        output.authStatus.subscribe(with: self) { owner, state in
            print(#function, state)
        } onCompleted: { value in
            print(#function, "Completed", value)
        }
        .disposed(by: disposeBag)
    }
    
//    private func bind(){
//        let input = SignUpViewModel.Input(email: emailTextField.rx.text.orEmpty, password: passwordTextField.rx.text.orEmpty, signUpButtonClicked: signUpButton.rx.tap)
//
//        let output = viewModel.transform(input: input)
//
//        output.authStatus.subscribe(with: self) { owner, state in
//            print(#function, state)
//        } onError: { owner, error in
//            print(#function, error)
//        } onCompleted: { value in
//            print(#function, "Completed", value)
//        }
//        .disposed(by: disposeBag)
//    }
    
}
