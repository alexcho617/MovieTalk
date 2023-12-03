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
            .drive { state in
                if state == AuthState.loggedIn{
                    //이 메시지가 여러번 출력 된다는건 ouput.authStatus에서 이벤트가 여러번 방출되고 있다는 뜻.
                    print(state,"Login Success, go to home")
                    //change rootview
                    let tabBarController = UITabBarController()
                    let homeVC = UINavigationController(rootViewController: HomeViewController())
                    let searchVC = UINavigationController(rootViewController: SearchViewController())
                    let profileVC = UINavigationController(rootViewController: ProfileViewController())
                    let devVC = UINavigationController(rootViewController: SettingsViewController())
                    
                    tabBarController.setViewControllers([homeVC, searchVC, profileVC, devVC], animated: true)
                    tabBarController.tabBar.tintColor = .label
                    
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.backgroundColor = .systemBackground
                    tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance //끝에 있을때: 맨 아래로 내려가있을때
                    tabBarController.tabBar.standardAppearance = tabBarAppearance //끝에 닿지 않을때 NavigationBar랑 반대임
                    
                    if let items = tabBarController.tabBar.items{
                        items[0].image = UIImage(systemName: "house.fill")
//                        items[0].title = "홈"
                        
                        items[1].image = UIImage(systemName: "movieclapper")
//                        items[1].title = "추가"
                        
                        items[2].image = UIImage(systemName: "person")
//                        items[2].title = "프로필"
                        
                        items[3].image = UIImage(systemName: "hammer")
//                        items[3].title = "개발"
                    }
                }else{
                    print(state,"Login Failed")
                }
            }.disposed(by: disposeBag)
        
        output.isValidated
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc func signUpRouterClicked(){
        print("Go to sign up")
        //nc가 없어서 그런가?
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
}
