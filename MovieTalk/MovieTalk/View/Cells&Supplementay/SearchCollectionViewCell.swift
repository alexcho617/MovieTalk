//
//  SearchCollectionViewCell.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/25/23.
//

import UIKit
import RxSwift
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    var disposeBag = DisposeBag()
    
    let posterImage = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.tintColor = .white
        view.image = UIImage(systemName: "popcorn")
        view.layer.cornerRadius = Design.paddingDefault
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let title = {
        let view = UILabel()
        view.font = Design.fontDefault
        view.textColor = .label
        view.numberOfLines = 2
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureCell(){
        contentView.addSubview(title)
        contentView.addSubview(posterImage)
        
        posterImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            make.bottom.equalToSuperview().offset(-Design.paddingDefault)
        }

    }
    
    func configureCellData(_ cellData: MovieResponseDTO) {
        title.text = "\(cellData.title ?? "") (\(DateFormatter.movieYear(fromReleaseDateString: cellData.releaseDate ?? "9999-99-99") ?? ""))"
        posterImage.kf.setImage(with: Secret.getEndPointImageURL(cellData.posterPath ?? ""),placeholder: UIImage(systemName: "popcorn") ,options: [.cacheOriginalImage])
    }
    
    //Codebase initialize
    override init(frame: CGRect){
        super.init(frame: frame)
        configureCell()
    }
    
    //Storyboard initialize
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
