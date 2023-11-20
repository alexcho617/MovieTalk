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
        textField.placeholder = "이메일"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
//    private let phoneNumberTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "phoneNumber"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//
//    private let birthdayTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "birthday"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
    private let validateEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        return button
    }()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하기", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bind()
    }
    
    private func setView() {
        view.backgroundColor = .systemBackground
        title = "회원가입"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(emailTextField)
        view.addSubview(validateEmailButton)
        
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        validateEmailButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField)
            make.leading.equalTo(emailTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func bind(){
        
        let input = SignUpViewModel.Input(
            email: emailTextField.rx.text.orEmpty,
            password: passwordTextField.rx.text.orEmpty,
            nickname: nicknameTextField.rx.text.orEmpty,
            validateEmailButtonClicked: validateEmailButton.rx.tap,
            signUpButtonClicked: signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.authStatus
            .drive { state in
                print(#function, state)
                if state == AuthState.signedUp{
                    //TODO: 한번에 로그인 시키고 홈으로 가기
                    //일단은 로그인 화면으로
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    
                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                    
                }
            }
            .disposed(by: disposeBag)

        output.isValidated
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
}
