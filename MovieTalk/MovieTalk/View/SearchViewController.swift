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
    
    //TODO: 로딩 인디케이터 사용 안하고 있음
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
        navigationItem.titleView = searchBar
    }
    
    func setConstraints(){
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
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
                    owner.searchBar.resignFirstResponder()
                    self.present(vc, animated: true, completion: nil)
                }
               
            }.disposed(by: disposeBag)
        //검색시 키보드 내림
        searchBar.rx.searchButtonClicked
            .bind { _ in
                self.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
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
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 16, height: 300)
        return layout
    }
}
