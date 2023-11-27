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
    
    //MARK: View Component
    let backdropImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .systemGray
        return view
    }()
    
    let scrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let contentsView = {
        return UIView()
    }()
    
    
    let posterImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    let gradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    lazy var infoStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, originalTitleLabel, infoLabel, genreLabel])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = Design.paddingDefault
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "-"
        view.numberOfLines = 0
        view.textColor = Design.colorTextTitle
        view.font = Design.fontTitle
        return view
    }()
    
    let originalTitleLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "-"
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontDefault
        return view
    }()
    
    let infoLabel = {
        let view = UILabel()
        view.text = "-"
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontDefault
        return view
    }()
    
    let genreLabel = {
        let view = UILabel()
        view.text = "-"
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontDefault
        return view
    }()
    
    //TODO: \n\n 처리를 어떻게 해줄 것인가?
    let expandableDescriptionLabel = {
        let view = UILabel()
        view.text = "-"
        view.font = Design.fontDefault
        view.textColor = .white
        return view
    }()
    
    let expandButton = {
        let view = UIButton()
        view.tintColor = .white
        view.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        return view
    }()
    
    let footerView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    //MARK: End of View Component

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = posterImageView.frame
    }
    
    func setView(){
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
        view.backgroundColor = .black
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentsView)
        
        contentsView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)

        contentsView.addSubview(infoStackView)
        contentsView.addSubview(expandableDescriptionLabel)
        contentsView.addSubview(expandButton)
        contentsView.addSubview(footerView)

        contentsView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }

        infoStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            //아래서 위로
            make.bottom.equalTo(posterImageView.snp.bottom)
            make.height.equalTo(120)
        }
        
        expandableDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
        }
        
        expandButton.snp.makeConstraints { make in
            make.top.equalTo(expandableDescriptionLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        footerView.snp.makeConstraints { make in
            make.top.equalTo(expandButton.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(150)
            make.bottom.equalToSuperview()
        }
        
        //https://api.themoviedb.org/3/movie/671/images?api_key=42de580fd67c2991513fc60dfa628a99
        //TODO: 이미지 API 사용해서 이미지 스틸컷들 쭉 보여줘도 좋을듯.

    }
    
    func bind(_ movieID: String){
        let input = MovieViewModel.Input(didClickExpand: expandButton.rx.tap, movieID: movieID)
        let output = viewModel.transform(input: input)
        
        //TODO: 에러 처리 확인
        output.movieData
            .subscribe(with: self) { owner, data in
                //image
                owner.titleLabel.text = data.title
                owner.originalTitleLabel.text = data.originalTitle
                owner.infoLabel.text = "\(data.releaseDate ?? "-")개봉" + " | "  + "\(data.runtime ?? 0)분"
                owner.genreLabel.text = data.genres?.first?.name
                owner.expandableDescriptionLabel.text = data.overview
                owner.posterImageView.kf.setImage(with: Secret.getEndPointImageURL(data.posterPath ?? ""))
                owner.backdropImageView.kf.setImage(with: Secret.getEndPointImageURL(data.backdropPath ?? ""))
            }.disposed(by: disposeBag)
        
        //영화 설명 레이블 줄 수 토글
        output.isExpanded
            .subscribe(with: self) { owner, isExpanded in
                if isExpanded{
                    owner.expandableDescriptionLabel.numberOfLines = 0
                    owner.expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                }
                else{
                    owner.expandableDescriptionLabel.numberOfLines = 2
                    owner.expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
}
