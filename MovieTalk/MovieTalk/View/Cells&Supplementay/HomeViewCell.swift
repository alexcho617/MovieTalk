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
    private let nickLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Movie"
        return label
    }()
    
    let movieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("영화정보보기", for: .normal)
        return button
    }()

    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        mainImageView.image = nil
        contentLabel.text = nil
    }

    func configureCell() {
        contentView.addSubview(nickLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(movieLabel)
        contentView.addSubview(movieButton)
        movieButton.addTarget(self, action: #selector(movieButtonClicked), for: .touchUpInside)
        contentView.addSubview(mainImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(moreButton)
        
        nickLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        movieLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalTo(movieButton.snp.leading)
            make.bottom.equalTo(mainImageView.snp.top)
        }
        movieButton.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.top)
            make.leading.equalTo(movieLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(mainImageView.snp.top)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            //calculate height?
//            make.height.equalTo(200)
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.bottom.equalTo(titleLabel.snp.top)
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentLabel.snp.top)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(moreButton.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    func configureCellData(_ cellData: Post) {

        nickLabel.text = cellData.creator.nick
        dateLabel.text = cellData.time
        //TODO: replace with cellData image
        //TODO: Request image from sesac server
        mainImageView.kf.setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280/unEtC8uWn2lcQLnwKG9PZJX0h0c.jpg"), options: [.cacheOriginalImage])
        titleLabel.text = cellData.title
        
        contentLabel.text = "\(cellData.creator.nick): " + simulateVariableText(text: cellData.content) //simulate multiple lines
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
