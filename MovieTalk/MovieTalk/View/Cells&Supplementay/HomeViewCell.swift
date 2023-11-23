//
//  CollectionViewCell.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import UIKit
import SnapKit

class HomeViewCell: UICollectionViewCell {
    static let idenifier = "HomeViewCell"
    var cellData: Post?
    
    private let title = {
        let view = UILabel()
        return view
    }()
    
    private let content = {
        let view = UILabel()
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    func configureCell(){
        addSubview(title)
        addSubview(content)
        
        title.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
        }
        content.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        bind()
    }
    func bind(){
        guard let cellData else {return}
        title.text = cellData.title
        content.text = cellData.content
    }
}
