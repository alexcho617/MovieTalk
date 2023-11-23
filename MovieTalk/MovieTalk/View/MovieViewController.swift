//
//  MovieViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MovieViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = MovieViewModel()
    var movieID: String = ""
    
    let posterImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.movieID = movieID
        setView()
        bind()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
        view.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }

    }
    
    func bind(){
        let input = MovieViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.movieContents
            .subscribe(with: self) { owner, response in
                //image
                owner.posterImageView.kf.setImage(with: Secret.getEndPointImageURL(response.posterPath ?? ""))
                
                
            }.disposed(by: disposeBag)
    }
    
}
