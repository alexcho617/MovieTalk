//
//  AddViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/24/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    let searchBar = {
        let view = UISearchBar()
        view.layer.cornerRadius = Design.paddingDefault
        view.barTintColor = .white.withAlphaComponent(0.5)
        view.placeholder = "영화를 검색하세요"
        view.clipsToBounds = true
        view.searchTextField.textColor = .label
        return view
    }()
    
    let activityIndicator = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = UIColor.label
        view.backgroundColor = Design.debugBlue
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        view.backgroundColor = .clear
        return view
    }()
    
    func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 16, height: 300)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        bind()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("Search Appeared")
//    }
    
    func setView(){
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        view.addSubview(activityIndicator)
        searchBar.becomeFirstResponder()
    }
    
    func setConstraints(){
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Design.paddingDefault)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
            
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(4*Design.paddingDefault)
        }
    }
    
    //TODO: 비어있을때 tmdb trend api 써서 미리 보여줌.
    func bind(){
        let input = SearchViewModel.Input(searchQueryEntered: searchBar.rx.text.orEmpty, searchButtonClicked: searchBar.rx.searchButtonClicked)
        
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .drive(collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)){ row, element, cell in
                cell.configureCellData(element)
            }
            .disposed(by: disposeBag)
        
        output.scrollToTop
            .drive(onNext: { [weak self] in
                self?.scrollToTop()
            })
            .disposed(by: disposeBag)
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(MovieResponseDTO.self))
            .map { (indexPath, selectedData) in //set
                return selectedData
            }
            .subscribe(with: self) { owner, selectedData in
                //이미지 데이터 먼저 생성 후 completion 호출
                owner.getImageData(selectedData: selectedData) { backdropImage in
                    let vc = AddPostViewController()
                    vc.bind(selectedData, backdropImage) //시점 떄문에 이미지 생성 후 같이 넘김
                    if let sheet = vc.sheetPresentationController{
                        sheet.detents = [.large()]
                        sheet.prefersGrabberVisible = true
                    }
                    self.present(vc, animated: true, completion: nil)
                }
               
            }.disposed(by: disposeBag)
    }
    
    private func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    private func getImageData(selectedData: MovieResponseDTO, completion: @escaping (UIImage) -> Void){
        KingfisherManager.shared.retrieveImage(with: Secret.getEndPointImageURL(selectedData.backdropPath ?? selectedData.posterPath ?? "")) { result in
            switch result{
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Cannot get movie image Error", error)
            }
        }
    }
}
