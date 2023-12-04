//
//  ProfileViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/2/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Tabman

class ProfileViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = ProfileViewModel()
    
    //view
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let nickLabel = {
        let view = UILabel()
        view.text = "mysamplenickname"
        view.font = Design.fontSubTitle
        view.textColor = Design.colorBlack
        return view
    }()
    
    let emailLabel = {
        let view = UILabel()
        view.text = "mysample@gmail.com"
        view.font = Design.fontDefault
        view.textColor = Design.colorGray
        return view
    }()
    
    let phoneLabel = {
        let view = UILabel()
        view.text = "010-5024-3225"
        view.font = Design.fontDefault
        view.textColor = Design.colorGray
        return view
    }()
    
    let birthdayLabel = {
        let view = UILabel()
        view.text = "2000.12.02."
        view.textColor = Design.colorGray
        view.font = Design.fontDefault
        return view
    }()
    
    let postCountLabel = {
        let view = UILabel()
        view.text = "25\n게시물"
        view.font = Design.fontDefault
        view.textColor = Design.colorGray
        return view
    }()
    
    let followerCountLabel = {
        let view = UILabel()
        view.text = "1,120\n팔로워"
        view.font = Design.fontDefault
        view.textColor = Design.colorGray
        return view
    }()
    
    let followingCountLabel = {
        let view = UILabel()
        view.text = "2,201\n팔로잉"
        view.font = Design.fontDefault
        view.textColor = Design.colorGray
        return view
    }()
    
    //vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bind()
    }
    
    func setView(){
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        view.addSubview(nickLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(postCountLabel)
        view.addSubview(followerCountLabel)
        view.addSubview(followingCountLabel)
        setConstraints()
    }
    
    func setConstraints(){
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault * 2)
            make.size.equalTo(80)
            profileImageView.layer.cornerRadius = 40
        }
        
        nickLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(Design.paddingDefault)
            make.leading.equalTo(profileImageView.snp.trailing).offset(Design.paddingDefault * 2)
            make.trailing.equalToSuperview().inset(Design.paddingDefault * 2)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom)
            make.leading.trailing.equalTo(nickLabel)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom)
            make.leading.trailing.equalTo(nickLabel)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom)
            make.leading.trailing.equalTo(nickLabel)
            make.height.equalTo(20)
        }
        
        
    }
    
    func bind(){
        
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
            
    }

}
