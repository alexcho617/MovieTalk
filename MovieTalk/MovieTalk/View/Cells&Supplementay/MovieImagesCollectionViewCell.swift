//
//  MovieImagesCollectionViewCell.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/7/23.
//

import UIKit
import SnapKit

class MovieImagesCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    //Codebase initialize
    override init(frame: CGRect){
        super.init(frame: frame)
        configureCell()
    }
    
    //Storyboard initialize blocked
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
