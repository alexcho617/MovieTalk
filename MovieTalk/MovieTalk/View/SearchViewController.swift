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

final class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    
    let searchBar = {
        let view = UISearchBar()
        view.barTintColor = .clear
        view.searchTextField.textColor = .white
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
        view.backgroundColor = .black
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
    
    func setView(){
        view.backgroundColor = .black
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
            make.height.equalTo(40)
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
    
    //비어있을때 tmdb trend api 써서 미리 보여줌.
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
        
        //cell 선택시 add 화면 sheet pop up
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(MovieResponseDTO.self))
            .map { (indexPath, selectedData) in //set
//                print("Selected",indexPath, selectedData)
                return selectedData
            }
            .subscribe(with: self) { owner, selectedData in
//                print("selectedData", selectedData)
                
                let vc = AddPostViewController()
                vc.bind(selectedData)
                if let sheet = vc.sheetPresentationController{
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                }
                self.present(vc, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
    private func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }
    
}
