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
import Kingfisher
import PhotosUI

class ProfileViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = ProfileViewModel()
    var itemProviders: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?
    var photoConfig = PHPickerConfiguration()
    lazy var photoPicker = PHPickerViewController(configuration: photoConfig)

    
    //view
    //TODO: Pull to refresh
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let clearProfileButton = {
        let view = UIButton()
        view.backgroundColor = .clear
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
        view.textAlignment = .center
        view.numberOfLines = 2
        view.text = "-\n게시물"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    let followerCountLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 2
        view.text = "-\n팔로워"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    let followingCountLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 2
        view.text = "-\n팔로잉"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    lazy var statisticsStackView = {
        let view = UIStackView(arrangedSubviews: [postCountLabel, followerCountLabel, followingCountLabel])
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var postCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
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
        view.addSubview(clearProfileButton)
        view.addSubview(nickLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(statisticsStackView)
        view.addSubview(postCollectionView)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        postCollectionView.delegate = self
        
        photoConfig.selectionLimit = 1
        photoConfig.filter = .images
        photoPicker.delegate = self
        setConstraints()
    }
    
    func setConstraints(){
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault * 2)
            make.size.equalTo(80)
            profileImageView.layer.cornerRadius = 40
        }
        
        clearProfileButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView)
            clearProfileButton.layer.cornerRadius = 40
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
        
        statisticsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(statisticsStackView.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
    }
    
    func bind(){
        
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.myprofileRelay
            .bind(with: self, onNext: { owner, myProfileResponse in
//                print(myProfileResponse)
                owner.nickLabel.text = myProfileResponse.nick
                owner.emailLabel.text = myProfileResponse.email
                owner.phoneLabel.text = myProfileResponse.phoneNum
                owner.birthdayLabel.text = myProfileResponse.birthDay
                //debug
                //                let testProfilePath: String? = "uploads/posts/1701335519852.png"
                //                if let profileURL = testProfilePath{
                
                if let profileURL = myProfileResponse.profile{
                    let imageRequestString = Secret.baseURLString + profileURL + Secret.imageQuery
                    owner.profileImageView.kf.setImage(
                        with: URL(string: imageRequestString),
                        placeholder: UIImage(systemName: "person.fill"),
                        options: [.requestModifier(owner.getRequestModifier()), .cacheOriginalImage]
                    )
                }else{
                    owner.profileImageView.image = UIImage(systemName: "person.fill")
                    owner.profileImageView.tintColor = UIColor.random()
                }
                //statistics
                owner.postCountLabel.text = "\(myProfileResponse.posts?.count ?? 0)\n게시물"
                owner.followerCountLabel.text = "\(myProfileResponse.followers.count )\n팔로워"
                owner.followingCountLabel.text = "\(myProfileResponse.following.count )\n팔로잉"
            })
            .disposed(by: disposeBag)

        output.mypostRelay
            .bind(to: postCollectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)){ row, element, cell in
                cell.configureData(post: element)
            }
            .disposed(by: disposeBag)
        
        clearProfileButton.rx.tap.bind { [self] _ in
            print("Profile Tap")
            present(photoPicker, animated: true)
        }
        .disposed(by: disposeBag)
        
    }
    
    
    private func getRequestModifier() -> AnyModifier{
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(Secret.key, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.currentToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        return imageDownloadRequest
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let width =  (UIScreen.main.bounds.width)/3 - 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        return layout
    }
}


extension ProfileViewController: UICollectionViewDelegate{
    
}

extension ProfileViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        dismiss(animated: true)
        itemProviders = results.map(\.itemProvider)
        iterator = itemProviders.makeIterator()
        handleImage()
    }
    
    
    func handleImage() {
        print(#function)
            if let itemProvider = iterator?.next(), itemProvider.canLoadObject(ofClass: UIImage.self) {
                let currentImage = profileImageView.image
                
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] pickedImage, error in
                    DispatchQueue.main.async {
                        guard let self = self, let pickedImage = pickedImage as? UIImage, self.profileImageView.image == currentImage else { return }
                        self.profileImageView.image = pickedImage
                        //TODO: Upload to server
                        //사진 제외 다른 정보는 변경 없이 그냥 그대로 올리는걸로. 사진 올리는건 멀티파트 데이터 사용하고 사진 크기 1메가 이하로 줄여야함
                        let profileImage = self.profileImageView.image ?? UIImage(systemName: "person")
                        var profileData = profileImage?.jpegData(compressionQuality: 1.0) ?? Data()
                        var quality: CGFloat = 1.0
                        print("BEFORE:Compression Quality:",quality, "profileData:",profileData.count.formatted())

                        //원래 1MB 제한이나 여유있게 900KB으로 잡음
                        while profileData.count > 900000{
                            quality -= 0.1
                            profileData = profileImage?.jpegData(compressionQuality: quality) ?? Data()
                        }
                        
                        guard profileData.count < 900000 else {
                            print("Failed to downsize")
                            return
                        }
                        print("AFTER:Compression Quality:",quality, "profileData:",profileData.count.formatted())
                        let model = MyProfileEditRequestDTO(nick: self.nickLabel.text, phoneNum: self.phoneLabel.text, birthDay: self.birthdayLabel.text, profile: profileData)
                        self.viewModel.editProfile(model: model)
                    }
                   
                }
            }
        }
    
}
