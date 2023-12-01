//
//  CommentsTableViewCell.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/30/23.
//

import UIKit
import SnapKit
import RxSwift

class CommentsTableViewCell: UITableViewCell {
    static let identifier = "CommentsTableViewCell"
    var disposeBag = DisposeBag()
    
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.fill")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.font = Design.fontAccentDefault
        view.textColor = .label
        view.numberOfLines = 1
        return view
    }()
    
    let timeLabel = {
        let view = UILabel()
        view.font = Design.fontDefault
        view.textColor = Design.colorTextSubTitle
        view.numberOfLines = 1
        return view
    }()
    
    
    let commentLabel = {
        let view = UILabel()
        view.font = Design.fontDefault
        view.textColor = .label
        view.numberOfLines = 0
        return view
    }()
    
    func configureCell(){
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(commentLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Design.paddingDefault)
            profileImageView.layer.cornerRadius = 15
            make.size.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(Design.paddingDefault)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(nameLabel.snp.trailing).offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalTo(nameLabel)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.bottom.equalToSuperview().inset(Design.paddingDefault)
        }
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
