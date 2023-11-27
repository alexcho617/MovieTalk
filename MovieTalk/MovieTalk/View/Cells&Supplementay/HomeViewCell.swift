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
    var disposeBag = DisposeBag()
    var navigationHandler: (() -> Void)?
    
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
        label.text = "기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목기본영화제목"
        label.font = Design.fontDefault
        label.textColor = Design.colorTextDefault
        return label
    }()
    
    let movieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("영화정보", for: .normal)
        return button
    }()
    
    //backdrop 이미지를 사용하면 어떨까?
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
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
    
    let contentLabel: UILabel = {
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
    
    let lookCommentsButton = {
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
        contentView.addSubview(movieButton)
        movieButton.addTarget(self, action: #selector(movieButtonClicked), for: .touchUpInside)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(lookCommentsButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Design.paddingDefault)
            make.size.equalTo(30)
            profileImageView.layer.cornerRadius = 15
        }
        
        nickLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(profileImageView.snp.trailing).offset(Design.paddingDefault)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom).offset(Design.paddingDefault)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
        movieLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualTo(movieButton.snp.leading).offset(-Design.paddingDefault)
        }
        
        movieButton.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.top)
            
            make.trailing.equalToSuperview().offset(-Design.paddingDefault)
            make.bottom.equalTo(mainImageView.snp.top)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalToSuperview().offset(Design.paddingDefault)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(likeButton.snp.trailing).offset(Design.paddingDefault)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(Design.paddingDefault)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.bottom.equalToSuperview().priority(.high)
        }
        
        lookCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.leading.equalToSuperview().inset(Design.paddingDefault)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configureCellData(_ cellData: Post) {
        
        nickLabel.text = cellData.creator.nick
        dateLabel.text = cellData.time
        movieLabel.text = cellData.movieTitle
        //TODO: Request image from sesac server & replace with cellData image
        mainImageView.kf.setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280/unEtC8uWn2lcQLnwKG9PZJX0h0c.jpg"), options: [.cacheOriginalImage])
        titleLabel.text = cellData.title
        
        contentLabel.text = simulateVariableText(text: cellData.content) //simulate multiple lines
    }
    
    @objc func movieButtonClicked(){
        //closure
        navigationHandler?()
    }
    
    func simulateVariableText(text: String) -> String {
        let count = Int.random(in: 10...10)
        var output: String = ""
        
        for _ in 0..<count {
            output += text
        }
        
        return output
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
