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
import Kingfisher

final class MovieViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = MovieViewModel()
    var dataSource: UICollectionViewDiffableDataSource<Int, MovieImage>!

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
    
    lazy var imageCollectionView = {
        let view = BaseCollectionView(frame: .zero, collectionViewLayout: getPlaceholderLayout())
        view.backgroundColor = .black
        view.isScrollEnabled = false
        return view
    }()
    
    //MARK: End of View Component
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        configureDataSource()
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
        contentsView.addSubview(imageCollectionView)

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
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(expandButton.snp.bottom)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(150)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configureSnapshot(_ item: [MovieImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MovieImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(item)
        dataSource.apply(snapshot)
    }
    
    func configureDataSource(){
        let cellRegi = UICollectionView.CellRegistration<MovieImagesCollectionViewCell, MovieImage> { cell, indexPath, itemIdentifier in
            cell.imageView.kf.setImage(with: Secret.getEndPointImageURL(itemIdentifier.filePath ?? ""), placeholder: UIImage(systemName: "popcorn"))

        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegi, for: indexPath, item: itemIdentifier)
        })
        
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
        
        //TODO: 영화 이미지 API 로 쎌 뿌려주기 -> 백드롭 이미지들의 비율이 전부 1.778 쯤이라 다 똑같이 나온다.. 이렇게 되면 diffable쓴 메리트가 떨어진다.
        output.movieImages
            .bind(with: self, onNext: { owner, results in
                let ratios = results.map{ Ratio(ratio: $0.aspectRatio ?? 1.0) }
                let paths = results.map{$0.filePath}
                print(paths)
                let layout = CompositionalLayout(columnsCount: 2, itemRatios: ratios, spacing: Design.paddingDefault, contentWidth: self.view.frame.width)
                owner.imageCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: layout.section)
                owner.configureSnapshot(results)
                
            })
            .disposed(by: disposeBag)
        
    }
 
    private func getPlaceholderLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 16, height: 300)
        return layout
    }
}
