//
//  PostCollectionViewCell.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/11/23.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    var disposeBag = DisposeBag()
    
    let movieImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.tintColor = .white
        view.backgroundColor = .black
        return view
    }()
    
    func configureData(post: Post){

        if let imageURL = post.image?.first{
            let imageRequestString = Secret.baseURLString + imageURL + Secret.imageQuery
            movieImageView.kf.setImage(
                with: URL(string: imageRequestString),
                placeholder: UIImage(systemName: "star"),
                options: [.requestModifier(KingfisherManager.getRequestModifier()), .cacheOriginalImage]
            )
        }else{
            movieImageView.image = UIImage(systemName: "popcorn")
        }
        
    }
    
    func configureCell(){
        contentView.addSubview(movieImageView)
        movieImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    //Codebase initialize
    override init(frame: CGRect){
        super.init(frame: frame)
        configureCell()
    }
    
    //Storyboard initialize
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
