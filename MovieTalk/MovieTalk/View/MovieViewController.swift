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
        view.text = "해리포터와 마법사의 돌"
        view.numberOfLines = 0
        view.textColor = Design.colorTextTitle
        view.font = Design.fontTitle
        return view
    }()
    
    let originalTitleLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Harry Potter and Philosopher's Stone"
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontDefault
        return view
    }()
    
    let infoLabel = {
        let view = UILabel()
        view.text = "2001-11-16개봉" + " | "  + "\(152)분"
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontDefault
        return view
    }()
    
    let genreLabel = {
        let view = UILabel()
        view.text = "모험, 판타지"
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontDefault
        return view
    }()
    
    //TODO: \n\n 처리를 어떻게 해줄 것인가?
    let expandableDescriptionLabel = {
        let view = UILabel()
        view.text = "해리 포터는 위압적인 버논 숙부와 냉담한 이모 페투니아, 욕심 많고 버릇없는 사촌 더즐리 밑에서 갖은 구박을 견디며 계단 밑 벽장에서 생활한다.\n\n 이모네 식구들 역시 해리와의 동거가 불편하기는 마찬가지.\n\n 이모 페투니아에겐 해리가 이상한 언니 부부에 관한 기억을 떠올리게 만드는 달갑지 않은 존재다. 11살 생일이 며칠 앞으로 다가왔지만 한번도 생일파티를 치르거나 제대로 된 생일선물을 받아 본 적이 없는 해리로서는 특별히 신날 것도 기대 할 것도 없다.\n\n 11살 생일을 며칠 앞둔 어느 날 해리에게 초록색 잉크로 쓰여진 한 통의 편지가 배달된다. \n\n그 편지의 내용은 다름 아닌 해리의 11살 생일을 맞이하여 호그와트에서 보낸 입학 초대장이었다. 그리고 해리의 생일을 축하하러 온 거인 해그리드는 해리가 모르고 있었던 해리의 진정한 정체를 알려주는데..."
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
        viewModel.movieID = movieID
        setView()
        bind()
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
        //TODO: 사용해서 이미지들 쭉 보여줘도 좋을듯

    }
    
    func bind(){
        let input = MovieViewModel.Input(didClickExpand: expandButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        //data 처리
        //TODO: 에러 처리 확인
        output.movieData
            .subscribe(with: self) { owner, data in
                //image
                
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
