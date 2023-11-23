//
//  LoginViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 2023/11/13.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    private let signUpRouterButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원이 아니신가요?", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bind()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
        title = "로그인"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpRouterButton)
        signUpRouterButton.addTarget(self, action: #selector(signUpRouterClicked), for: .touchUpInside)
        
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        signUpRouterButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    func bind(){
        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty, password: passwordTextField.rx.text.orEmpty, loginClicked: loginButton.rx.tap)
        
        
        let output = viewModel.transform(input: input)
        
        output.authStatus
//            .debug("AUTH STATUSSSS")
            .drive { state in
                if state == AuthState.loggedIn{
                    //이 메시지가 여러번 출력 된다는건 ouput.authStatus에서 이벤트가 여러번 방출되고 있다는 뜻.
                    print(state,"Login Success, go to home")
                    //change rootview
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let nav = UINavigationController(rootViewController: HomeViewController())
                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                }else{
                    print(state,"Login Failed")
                }
            }.disposed(by: disposeBag)
        
        output.isValidated
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc func signUpRouterClicked(){
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
}
