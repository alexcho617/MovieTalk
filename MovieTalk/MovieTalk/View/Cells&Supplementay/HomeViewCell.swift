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
    
    var navigationHandler: (() -> Void)?
    var presentationHandler: (() -> Void)?
    var reloadCompletion: (() -> Void)?
    var disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.backgroundColor = .black
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
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = Design.fontAccentDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
    let movieInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("영화정보", for: .normal)
        return button
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    //TODO: 댓글화면 sheet presentation 후 textfield에 바로 포커스
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.fontAccentDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
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
    
    //TODO: 댓글화면 sheet presentation
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
        mainImageView.image = nil
        contentLabel.text = nil
        
    }
    
    func configureCell() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(movieLabel)
        contentView.addSubview(movieInfoButton)
        movieInfoButton.addTarget(self, action: #selector(movieButtonClicked), for: .touchUpInside)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(allCommentsButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Design.paddingDefault)
            profileImageView.layer.cornerRadius = 15
            make.size.equalTo(30)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(30)
            make.leading.equalTo(profileImageView.snp.trailing).offset(Design.paddingDefault)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom).offset(Design.paddingDefault)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
        movieLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualTo(movieInfoButton.snp.leading).offset(-Design.paddingDefault)
        }
        
        movieInfoButton.snp.makeConstraints { make in
            make.centerY.equalTo(movieLabel)
            
            make.trailing.equalToSuperview().offset(-Design.paddingDefault)
            make.bottom.equalTo(mainImageView.snp.top)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1)
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
            make.bottom.equalTo(allCommentsButton.snp.top)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(30)
        }
        
        allCommentsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Design.paddingDefault)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureCellData(_ cellData: Post) {
        
        nickLabel.text = cellData.creator.nick
        dateLabel.text = cellData.time
        movieLabel.text = cellData.movieTitle
        
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
                mainImageView.kf.setImage(with: URL(string: imageRequestString),options: [.requestModifier(getRequestModifier()), .cacheOriginalImage])
            }
        }
        titleLabel.text = cellData.title
        contentLabel.text = cellData.content //TODO: 문단 구별이 되어있지 않아서 추가적인 parsing 필요
        
        //셀 로딩시 좋아요 버튼 세팅
        //TODO: LieksArray를 가져와서 분기처리를 할 수가 없음. 서버에 저장하는 사용자의 아이디값과 내 아이디 값이 다른데 이건 UD에 저장되어있는 내 문제인가?
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
//                print("뷰 좋아요  상태", self.isLiked)
                ContentsManager.shared.likePost(cellData.id, completion: { isNetworkSuccessful in
//                    print("통신성공?:", isNetworkSuccessful)
                    isNetworkSuccessful ? owner.updateLikeInfo() : ()
                })
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
