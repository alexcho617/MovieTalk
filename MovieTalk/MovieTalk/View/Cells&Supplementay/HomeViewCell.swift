//
//  CollectionViewCell.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//
import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeViewCell: UITableViewCell {
    static let identifier  = "HomeViewCell"
    
    var isLiked: Bool = false
    var likeCount: Int = 0
    
    var navigationHandler: (() -> Void)? //for movie VC
    var presentationHandler: (() -> Void)? //for comments VC
    var disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nickLabel: UILabel = {
        let label = UILabel()
        label.font = Design.fontAccentDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Design.fontSmall
        label.textColor = .systemGray
        return label
    }()
    
    let movieInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("영화정보", for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.titleLabel?.font = Design.fontAccentDefault
        return button
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart" ), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요 0개"
        label.font = Design.fontDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.fontAccentDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
    //TODO: line 수 가져와서 더보기 버튼 hidden   분기처리 하기
    var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Design.fontDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.setTitle("더 보기", for: .normal)
        button.titleLabel?.font = Design.fontSmall
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    let allCommentsButton = {
        let view = UIButton()
        view.setTitle("댓글 모두 보기", for: .normal)
        view.setTitleColor(.systemGray, for: .normal)
        view.titleLabel?.font = Design.fontDefault
        return view
    }()
        
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    func configureCell() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(mainImageView)
        contentView.addSubview(movieInfoButton)
        movieInfoButton.addTarget(self, action: #selector(movieButtonClicked), for: .touchUpInside)
        
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(allCommentsButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Design.paddingDefault)
            profileImageView.layer.cornerRadius = 20
            make.size.equalTo(40)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.height.equalTo(30)
            make.leading.equalTo(profileImageView.snp.trailing).offset(Design.paddingDefault)
        }
        

        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Design.paddingDefault)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1)
        }
        
        movieInfoButton.snp.makeConstraints { make in
            make.bottom.equalTo(mainImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()//.offset(Design.paddingDefault).priority(.high)
//            make.trailing.lessThanOrEqualToSuperview()//.inset(Design.paddingDefault)
        }
        
        ///button stack
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalToSuperview().offset(Design.paddingDefault)
            make.size.equalTo(30)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(likeButton.snp.trailing)
            make.trailing.equalTo(likeCountLabel.snp.leading).offset(-4)
            make.size.equalTo(30)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(Design.paddingDefault)
            make.height.equalTo(25)
        }
        ///button stack

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(30)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(30)
        }
        
        allCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalToSuperview().inset(Design.paddingDefault)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureCellData(_ cellData: Post) {
        
        nickLabel.text = cellData.creator.nick
        //profile image
        if let profileURL = cellData.creator.profile{
//            print("profile image url:", profileURL)
            let imageRequestString = Secret.baseURLString + profileURL + Secret.imageQuery
            profileImageView.kf.setImage(
                with: URL(string: imageRequestString),
                placeholder: UIImage(systemName: "person.fill"),
                options: [.requestModifier(getRequestModifier()), .cacheOriginalImage]
            )
        }else{
            profileImageView.image = UIImage(systemName: "person.fill")
            profileImageView.tintColor = UIColor.random()
        }
        dateLabel.text = DateFormatter.localizedDateString(fromTimestampString: cellData.time)
        movieInfoButton.setTitle("\(cellData.movieTitle ?? "-")\t", for: .normal)

        //image
        if let fileArray = cellData.image{
            if fileArray.count != 0{
                //MARK: using moya api
                //                ContentsManager.shared.fetchPostFile(fileArray.first ?? "")
                //                    .bind { fetchedImage in
                //                        self.mainImageView.image = fetchedImage
                //                    }.disposed(by: disposeBag)
                //MARK: Using kingfisher request modifier
                let imageRequestString = Secret.baseURLString + (fileArray.first ?? "") + Secret.imageQuery
                mainImageView.kf.setImage(
                    with: URL(string: imageRequestString),
                    placeholder: UIImage(systemName: "popcorn"),
                    options: [.requestModifier(getRequestModifier()), .cacheOriginalImage]
                )
            }
        }
        titleLabel.text = cellData.title
        contentLabel.text = cellData.content
        
        //셀 로딩시 좋아요 버튼 세팅
        if let likesArray = cellData.likes{
//            print("좋아요 배열",likesArray)
//            print("현재 로그인된 아이디",UserDefaultsManager.shared.currentUserID)
            isLiked = likesArray.contains(UserDefaultsManager.shared.currentUserID)
            likeCount = likesArray.count
        }
        updateLikeInfo()
        
        //좋아요 기능
        likeButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.isLiked.toggle()
                if owner.isLiked {
                    owner.likeCount += 1
                }else{
                    owner.likeCount = max(owner.likeCount - 1, 0)
                }
                ContentsManager.shared.likePost(cellData.id, completion: { isNetworkSuccessful in
                    isNetworkSuccessful ? owner.updateLikeInfo() : ()
                })
            }
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentationHandler?()
            }
            .disposed(by: disposeBag)
        
        //댓글 창
        allCommentsButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentationHandler?()
            }
            .disposed(by: disposeBag)



    }
    
    
    private func updateLikeInfo(){
       
        likeButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart" ), for: .normal)
        likeButton.tintColor = isLiked ? .red : .black
        likeCountLabel.text = likeCount > 0 ? "좋아요 \(likeCount)개" : ""
    }
    
    @objc func movieButtonClicked(){
        navigationHandler?()
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
    
    //디버깅을 위해 컨텐츠 길이를 늘려주는 함수
//    func simulateVariableText(text: String) -> String {
//        let count = Int.random(in: 5...10)
//        var output: String = ""
//        
//        for _ in 0..<count {
//            output += text
//        }
//        
//        return output
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
