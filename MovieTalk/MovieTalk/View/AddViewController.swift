//
//  AddViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/24/23.
//

import UIKit
import SnapKit

final class AddViewController: UIViewController {
    let someLabel = {
        let label = UILabel()
        label.text = "Add screen"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add"
        view.backgroundColor = .systemBackground
        view.addSubview(someLabel)
        //TODO: 뷰 구현하기
        someLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    


}
